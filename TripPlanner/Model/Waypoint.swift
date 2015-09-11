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
  
  override func willSave() {
    var changes = changedValues()
    changes.removeValueForKey("parsing")
    // if there aren't any relevant changes; return
    if changes.count == 0 { return }
    // for changes during parsing we don't want to modify the 'lastUpdate' timestamp
    if parsing?.boolValue == true { return }
    
    trip?.waypointUpdated()
  }
  
  func configureWithJSONWaypoint(waypoint: JSONWaypoint) {
    name = waypoint.name
    location = waypoint.location
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

