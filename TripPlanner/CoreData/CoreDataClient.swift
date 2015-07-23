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
  
  func createObjectInTemporaryContext<T: TripPlannerManagedObject>(object: T.Type) -> (T, NSManagedObjectContext) {
    let childContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    childContext.parentContext = context
    
    return (object.init(context: childContext), childContext)
  }
  
  func saveStack() -> Void {
    stack.save()
  }
  
}