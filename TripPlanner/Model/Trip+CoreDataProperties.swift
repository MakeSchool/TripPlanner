//
//  Trip+CoreDataProperties.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/30/15.
//  Copyright © 2015 Make School. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Trip {

    @NSManaged var location: NSObject?
    @NSManaged var locationDescription: String?
    @NSManaged var waypoints: NSSet?

}
