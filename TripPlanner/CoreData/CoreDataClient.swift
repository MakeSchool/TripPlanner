//
//  CoreDataClient.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/21/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataClient {
  
  let context: NSManagedObjectContext
  let stack: CoreDataStack
  
  init(stack: CoreDataStack) {
    self.stack = stack
    self.context = stack.managedObjectContext
  }
  
  func allTrips() -> [Trip] {
    return try! self.context.executeFetchRequest(NSFetchRequest(entityName: "Trip")) as! [Trip]
  }
  
  func tripWithServerID(serverID: String) -> Trip? {
    let fetchRequest = NSFetchRequest(entityName: "Trip")
    fetchRequest.predicate = NSPredicate(format: "serverID = %@", serverID)
    let trips = try! self.context.executeFetchRequest(fetchRequest) as! [Trip]
    
    if (trips.count > 0) {
      return trips[0]
    } else {
      return nil
    }

  }
  
  func createObjectInTemporaryContext<T: TripPlannerManagedObject>(objectType: T.Type) -> (T, NSManagedObjectContext) {
    let childContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    childContext.parentContext = context
    
    return (objectType.init(context: childContext), childContext)
  }
  
  func saveStack() -> Void {
    stack.save()
  }
  
}