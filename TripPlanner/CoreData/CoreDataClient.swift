//
//  CoreDataClient.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/21/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreData

typealias TripServerID = String

class CoreDataClient {
  
  let context: NSManagedObjectContext
  let stack: CoreDataStack
  let errorHandler = DefaultErrorHandler()
  
  init(stack: CoreDataStack) {
    self.stack = stack
    self.context = stack.managedObjectContext
  }
  
  func allTrips() -> [Trip] {
    return errorHandler.wrap {
      try context.executeFetchRequest(NSFetchRequest(entityName: "Trip")) as! [Trip]
    } ?? []
  }
  
  func allWaypoints() -> [Waypoint] {
    return errorHandler.wrap {
      try context.executeFetchRequest(NSFetchRequest(entityName: "Waypoint")) as! [Waypoint]
    } ?? []
  }
  
  func tripWithServerID(serverID: String) -> Trip? {
    let fetchRequest = NSFetchRequest(entityName: "Trip")
    fetchRequest.predicate = NSPredicate(format: "serverID = %@", serverID)
    let trips = errorHandler.wrap {
      try context.executeFetchRequest(fetchRequest) as! [Trip]
    } ?? []
    
    if (trips.count > 0) {
      return trips[0]
    } else {
      return nil
    }
  }
  
  func waypointWithServerID(serverID: String) -> Waypoint? {
    let fetchRequest = NSFetchRequest(entityName: "Waypoint")
    fetchRequest.predicate = NSPredicate(format: "serverID = %@", serverID)
    let waypoints = errorHandler.wrap {
      try context.executeFetchRequest(fetchRequest) as! [Waypoint]
    } ?? []
    
    if (waypoints.count > 0) {
      return waypoints[0]
    } else {
      return nil
    }
  }
  
  func unsyncedTrips() -> [Trip] {
    let fetchRequest = NSFetchRequest(entityName: "Trip")
    fetchRequest.predicate = NSPredicate(format: "serverID = nil")
    let unsyncedTrips = errorHandler.wrap {
      try context.executeFetchRequest(fetchRequest) as? [Trip]
    } ?? []
   
    return unsyncedTrips
  }
  
  func unsyncedTripDeletions() -> [TripServerID] {
    let syncInfo = syncInformation()
    return syncInfo.unsyncedDeletedTripsArray
  }
  
  func tripsThatChangedSince(timestamp: NSTimeInterval) -> [Trip] {
    let fetchRequest = NSFetchRequest(entityName: "Trip")
    fetchRequest.predicate = NSPredicate(format: "lastUpdate > %f", timestamp)
    let updatedTrips = errorHandler.wrap {
      try context.executeFetchRequest(fetchRequest) as! [Trip]
    } ?? []
    
    return updatedTrips
  }
  
  func syncedUpdateTripsChangedSince(timestamp: NSTimeInterval) -> [Trip] {
    let fetchRequest = NSFetchRequest(entityName: "Trip")
    fetchRequest.predicate = NSPredicate(format: "lastUpdate > %f AND serverID != nil", timestamp)
    let updatedTrips = errorHandler.wrap {
      try self.context.executeFetchRequest(fetchRequest) as! [Trip]
    } ?? []
    
    return updatedTrips
  }
  
  func markTripAsDeleted(trip: Trip) {
    let syncInfo = syncInformation()
    
    // remember deleted trips for synchronization
    if let tripServerID = trip.serverID {
      var deletedTripsArray = syncInfo.unsyncedDeletedTripsArray
      deletedTripsArray.append(tripServerID)
      syncInfo.unsyncedDeletedTripsArray = deletedTripsArray
    }
    
    // delete trip locally
    let tripInMainContext = context.objectWithID(trip.objectID) as! Trip
    context.deleteObject(tripInMainContext)
  }
  
  func deleteWaypoint(waypoint: Waypoint) {
    context.deleteObject(waypoint)
  }
  
  func createObjectInTemporaryContext<T: TripPlannerManagedObject>(objectType: T.Type) -> (T, NSManagedObjectContext) {
    let childContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    childContext.parentContext = context
    
    return (objectType.init(context: childContext), childContext)
  }
  
  func saveStack() -> Void {
    stack.save()
  }
  
  
  // MARK: Access to Sync Information
  
  /** 
    This data model only uses a single instance of `SyncInformation`. This acessor provides the single instance.
    If it does not exist yet it will be created.
  */
  func syncInformation() -> SyncInformation {
    let syncInformationFetchRequest = NSFetchRequest(entityName: "SyncInformation")
    let syncInformationEntities = try! self.context.executeFetchRequest(syncInformationFetchRequest) as! [SyncInformation]
    
    if (syncInformationEntities.count == 1) {
      return syncInformationEntities[0]
    } else if (syncInformationEntities.count > 1) {
      assertionFailure("Only one instance of SyncInformation should ever exist")
      return SyncInformation()
    } else {
      let syncInformation = SyncInformation(context: context)
      saveStack()
      
      return syncInformation
    }
  }
}
