//
//  Trip.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/21/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreData

final class Trip: NSManagedObject, TripPlannerManagedObject {

  convenience init(context: NSManagedObjectContext) {
    let entityDescription = NSEntityDescription.entityForName("Trip", inManagedObjectContext: context)!
    self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
  }
  
  func configureWithJSONTrip(jsonTrip: JSONTrip) {
    self.locationDescription = jsonTrip.locationDescription
  }
  
}