//
//  Waypoint+CoreDataProperties.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/31/15.
//  Copyright © 2015 Make School. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Waypoint {

    @NSManaged var name: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var trip: Trip?

}
