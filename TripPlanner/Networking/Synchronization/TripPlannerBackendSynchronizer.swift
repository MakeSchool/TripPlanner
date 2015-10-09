//
//  TripPlannerBackendSynchronization.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 9/9/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

struct TripPlannerBackendSynchronizer {
    
  var tripPlannerClient: TripPlannerClient
  var coreDataClient: CoreDataClient
  
  init(tripPlannerClient: TripPlannerClient = defaultTripPlannerClient(), coreDataClient: CoreDataClient) {
      self.tripPlannerClient = tripPlannerClient
      self.coreDataClient = coreDataClient
  }
      
  func downloadSync() -> Void {
      tripPlannerClient.fetchTrips {
        if case .Success(let trips) = $0 {
          
          let allLocalTripIds = self.coreDataClient.allTrips().map { $0.serverID }
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
                  return
                }
                
                // update existing trip
                existingTrip.configureWithJSONTrip(jsonTrip)
                
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
      }
  }
  
  func generateUploadRequests() -> (createTripRequests: [TripPlannerClientCreateTripRequest], deleteTripRequests: [TripPlannerClientDeleteTripRequest]) {
    let tripsToDelete = coreDataClient.unsyncedTripDeletions()
    let deleteRequests = tripsToDelete.map { tripPlannerClient.createDeleteTripRequest($0) }
    
    let tripsToPost = coreDataClient.unsyncedTrips()
    let postRequests = tripsToPost.map { tripPlannerClient.createCreateTripRequest($0) }
    
    return (createTripRequests: postRequests, deleteTripRequests: deleteRequests)
  }
  
}


    


private func defaultTripPlannerClient() -> TripPlannerClient {
    return TripPlannerClient(urlSession: NSURLSession.sharedSession())
}