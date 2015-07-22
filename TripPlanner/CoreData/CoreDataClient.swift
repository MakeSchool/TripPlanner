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
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func allTrips() -> [Trip] {
    return try! self.context.executeFetchRequest(NSFetchRequest(entityName: "Trip")) as! [Trip]
  }
  
}