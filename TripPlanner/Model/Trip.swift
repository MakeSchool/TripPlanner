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
  
  override func willSave() {
    // for changes during parsing we don't want to modify the 'lastUpdate' timestamp
    if parsing?.boolValue == true {
      return
    }
      
    setPrimitiveValue(NSDate.timeIntervalSinceReferenceDate(), forKey: "lastUpdate")
  }
  
  func configureWithJSONTrip(jsonTrip: JSONTrip) {
    locationDescription = jsonTrip.locationDescription
    lastUpdate = jsonTrip.lastUpdate
  }
  
}