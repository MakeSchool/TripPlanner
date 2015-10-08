//
//  SyncInformation.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 9/11/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreData

class SyncInformation: NSManagedObject {

  var unsyncedDeletedTripsArray: [TripServerID] {
    set {
      unsyncedDeletedTrips = NSKeyedArchiver.archivedDataWithRootObject(newValue)
    }
    
    get {
      return NSKeyedUnarchiver.unarchiveObjectWithData(unsyncedDeletedTrips!) as! [TripServerID]
    }
  }

}
