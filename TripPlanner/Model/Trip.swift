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
  
  func waypointUpdated() {
    if parsing?.boolValue == true { return }
    
    setPrimitiveValue(NSDate.timeIntervalSinceReferenceDate(), forKey: "lastUpdate")
  }
  
  override func willSave() {
    var changes = changedValues()
    changes.removeValueForKey("lastUpdate")
    changes.removeValueForKey("parsing")
    
    // if there aren't any relevant changes; return
    if changes.count == 0 { return }
    // for changes during parsing we don't want to modify the 'lastUpdate' timestamp
    if parsing?.boolValue == true { return }
      
    setPrimitiveValue(NSDate.timeIntervalSinceReferenceDate(), forKey: "lastUpdate")
  }
  
  func configureWithJSONTrip(jsonTrip: JSONTrip) {
    locationDescription = jsonTrip.locationDescription
    lastUpdate = jsonTrip.lastUpdate
  }
  
}