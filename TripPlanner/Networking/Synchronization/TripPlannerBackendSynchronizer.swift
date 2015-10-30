//
//  TripPlannerBackendSynchronization.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 9/9/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreData

struct TripPlannerBackendSynchronizer {
    
  var tripPlannerClient: TripPlannerClient
  var coreDataClient: CoreDataClient
  
  init(tripPlannerClient: TripPlannerClient = defaultTripPlannerClient(), coreDataClient: CoreDataClient) {
      self.tripPlannerClient = tripPlannerClient
      self.coreDataClient = coreDataClient
  }
  
  func sync(completion: () -> Void) {
    uploadSync {
      self.downloadSync {
        self.coreDataClient.syncInformation().lastSyncTimestamp = NSDate.currentTimestamp()
        self.coreDataClient.saveStack()
        completion()
      }
    }
  }
      
  func downloadSync(completionBlock: () -> Void) -> Void {
      tripPlannerClient.fetchTrips {
        if case .Success(let trips) = $0 {
          
          let allLocalTripIds = self.coreDataClient.allTrips().filter { $0.serverID != nil }.map { $0.serverID }
          // trips that exist locally, but not in the server set
          let tripsToDelete = allLocalTripIds.filter { localTripId in !trips.contains{ $0.serverID == localTripId } }
          
            tripsToDelete.forEach { tripServerID in
              let tripToDelete = self.coreDataClient.tripWithServerID(tripServerID!)
              self.coreDataClient.context.deleteObject(tripToDelete!)
            }
          
            trips.forEach { jsonTrip in
              let existingTrip = self.coreDataClient.tripWithServerID(jsonTrip.serverID!)
              
              if let existingTrip = existingTrip {
                existingTrip.parsing = true
                // check if server data is actually newer then local; if not return
                if (existingTrip.lastUpdate!.doubleValue > jsonTrip.lastUpdate) {
                  existingTrip.parsing = false
                  return
                }
                
                // update existing trip
                existingTrip.configureWithJSONTrip(jsonTrip)
                
                existingTrip.waypoints?.forEach { waypoint in
                  self.coreDataClient.context.deleteObject(waypoint as! NSManagedObject)
                }
                
                jsonTrip.waypoints.forEach {
                  var waypoint: Waypoint!
                  // check if waypoint already exists
          
                  let existingWaypoint = self.coreDataClient.waypointWithServerID($0.serverID!)
                  
                  if let existingWaypoint = existingWaypoint {
                    waypoint = existingWaypoint
                    waypoint.parsing = true
                  } else {
                    waypoint = Waypoint(context: existingTrip.managedObjectContext!)
                  }
                  
                  try! waypoint.managedObjectContext!.save()
                  waypoint.parsing = false
                  
                  waypoint.configureWithJSONWaypoint($0)
                  waypoint.trip = existingTrip
                }
                
                self.coreDataClient.saveStack()
                existingTrip.parsing = false
                self.coreDataClient.saveStack()
                
                return
              }
            
              let (newTrip, temporaryContext) = self.coreDataClient.createObjectInTemporaryContext(Trip.self)
              newTrip.configureWithJSONTrip(jsonTrip)
        
              jsonTrip.waypoints.forEach {
                  let wayPoint = Waypoint(context: temporaryContext)
                  wayPoint.configureWithJSONWaypoint($0)
                  wayPoint.trip = newTrip
                }
            
              try! temporaryContext.save()
              self.coreDataClient.saveStack()
            }
         }
        
        completionBlock()
      }
  }
  
  func uploadSync(completionBlock: () -> ()) {
    let (createTripRequests, updateTripRequests, deleteTripRequests) = generateUploadRequests()
    
    /* NOTE: 
      Instead of using a dispatch group most developers would use Promises or a framework like ReactiveCocoa that allows
      to create a sequence of different asynchronous tasks. However, this example solution tries not to use too many outside frameworks.
    
      Another possible solution would be using NSOperations and NSOperationQueue but that would require to restructure the TripPlannerClient significantly.
    */
    let uploadGroup = dispatch_group_create()
    
    for createTripRequest in createTripRequests {
      dispatch_group_enter(uploadGroup)
      createTripRequest.perform(tripPlannerClient.urlSession) {
        if case .Success(let trip) = $0 {
          // select uploaded trip
          let createdTrip = self.coreDataClient.context.objectWithID(createTripRequest.trip.objectID) as? Trip
          // assign server generated serverID
          createdTrip?.serverID = trip.serverID
          self.coreDataClient.saveStack()
        }
        dispatch_group_leave(uploadGroup)
      }
    }
    
    for updateTripRequest in updateTripRequests {
      dispatch_group_enter(uploadGroup)
      updateTripRequest.perform(tripPlannerClient.urlSession) {
        // in success case nothing needs to be done
        if case .Failure = $0 {
          // if failure ocurred we will need to try to sync this trip again
          // set lastUpdate in near future so that trip will be selected as updated trip again
          // TODO: use cleaner solution here
          // select updated trip
          let updatedTrip = self.coreDataClient.context.objectWithID(updateTripRequest.trip.objectID) as? Trip
          // update lastUpdate
          updatedTrip?.lastUpdate = NSDate.timeIntervalSinceReferenceDate() + 1000
          self.coreDataClient.saveStack()
        }
        dispatch_group_leave(uploadGroup)
      }
    }
    
    for deleteTripRequest in deleteTripRequests {
      dispatch_group_enter(uploadGroup)
      deleteTripRequest.perform(tripPlannerClient.urlSession) { 
        // in success case we can finally delete the trip
        if case .Success(let deletionResponse) = $0 {
          // remove trip from list of unsynced deletes
          var deletedTripsArray = self.coreDataClient.syncInformation().unsyncedDeletedTripsArray
          deletedTripsArray = deletedTripsArray.filter { $0 != deletionResponse.deletedTripIdentifier }
          self.coreDataClient.syncInformation().unsyncedDeletedTripsArray = deletedTripsArray
          self.coreDataClient.saveStack()
        }
        dispatch_group_leave(uploadGroup)
      }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      dispatch_group_wait(uploadGroup, DISPATCH_TIME_FOREVER)
      
      dispatch_async(dispatch_get_main_queue()) {
        completionBlock()
      }
    }
  }

  
  func generateUploadRequests() -> (createTripRequests: [TripPlannerClientCreateTripRequest], updateTripRequest: [TripPlannerClientUpdateTripRequest], deleteTripRequests: [TripPlannerClientDeleteTripRequest]) {
    let tripsToDelete = coreDataClient.unsyncedTripDeletions()
    let deleteRequests = tripsToDelete.map { tripPlannerClient.createDeleteTripRequest($0) }
    
    let tripsToPost = coreDataClient.unsyncedTrips()
    let postRequests = tripsToPost.map { tripPlannerClient.createCreateTripRequest($0) }
    
    let lastSyncTimestamp = coreDataClient.syncInformation().lastSyncTimestamp?.doubleValue ?? 0
    let tripsToUpdate = coreDataClient.syncedUpdateTripsChangedSince(lastSyncTimestamp)
    let putRequests = tripsToUpdate.map { tripPlannerClient.createUpdateTripRequest($0) }
    
    return (createTripRequests: postRequests, updateTripRequest: putRequests, deleteTripRequests: deleteRequests)
  }
  
}

private func defaultTripPlannerClient() -> TripPlannerClient {
    return TripPlannerClient(urlSession: NSURLSession.sharedSession())
}