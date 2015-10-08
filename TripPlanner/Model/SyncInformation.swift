//
//  SyncInformation.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 9/11/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreData

class SyncInformation: NSManagedObject, TripPlannerManagedObject {

  convenience required init(context: NSManagedObjectContext) {
    let entityDescription = NSEntityDescription.entityForName("SyncInformation", inManagedObjectContext: context)!
    self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
  }
  
  var unsyncedDeletedTripsArray: [TripServerID] {
    set {
      unsyncedDeletedTrips = NSKeyedArchiver.archivedDataWithRootObject(newValue)
    }
    
    get {
      if let unsyncedDeletedTrips = unsyncedDeletedTrips {
        return NSKeyedUnarchiver.unarchiveObjectWithData(unsyncedDeletedTrips) as! [TripServerID]
      } else {
        return []
      }
    }
  }

}
