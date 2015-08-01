//
//  Waypoint.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/30/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

final class Waypoint: NSManagedObject, TripPlannerManagedObject {

  convenience init(context: NSManagedObjectContext) {
    let entityDescription = NSEntityDescription.entityForName("Waypoint", inManagedObjectContext: context)!
    self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
  }
  
  var location: CLLocationCoordinate2D? {
    get {
      if let latitude = latitude, let longitude = longitude {
        return CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
      } else {
        return nil
      }
    }
    
    set {
      if let location = location {
        self.latitude = location.latitude
        self.longitude = location.longitude
      }
    }
  }

}