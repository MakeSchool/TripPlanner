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
import MapKit

final class Waypoint: NSManagedObject, TripPlannerManagedObject, MKAnnotation {

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
      if let location = newValue {
        self.latitude = location.latitude
        self.longitude = location.longitude
      } else {
        self.latitude = nil
        self.longitude = nil
      }
    }
  }
  
  //MARK: MKAnnotation
  
  var coordinate: CLLocationCoordinate2D {
    get {
      return location!
    }
  }
  
  var title: String? {
    get {
      return name
    }
  }

}

