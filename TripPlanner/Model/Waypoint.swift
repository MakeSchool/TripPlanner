//
//  Waypoint.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/30/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreData

@objc(Waypoint)
final class Waypoint: NSManagedObject, TripPlannerManagedObject {

  convenience init(context: NSManagedObjectContext) {
    let entityDescription = NSEntityDescription.entityForName("Waypoint", inManagedObjectContext: context)!
    self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
  }

}