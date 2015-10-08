//
//  SyncInformation+CoreDataProperties.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 9/11/15.
//  Copyright © 2015 Make School. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SyncInformation {

  @NSManaged var unsyncedDeletedTrips: NSData?
  @NSManaged var lastSyncTimestamp: NSNumber?
  
}
