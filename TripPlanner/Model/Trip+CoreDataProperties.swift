//
//  Trip+CoreDataProperties.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 9/9/15.
//  Copyright © 2015 Make School. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Trip {

    @NSManaged var location: NSObject?
    @NSManaged var locationDescription: String?
    @NSManaged var serverID: String?
    @NSManaged var waypoints: NSSet?

}
