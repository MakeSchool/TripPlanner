//
//  PlaceWithLocation+MKAnnotation.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/27/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class PlaceWithLocationAnnotation: NSObject, MKAnnotation {

  let placeWithLocation: PlaceWithLocation
  
  init(placeWithLocation: PlaceWithLocation) {
    self.placeWithLocation = placeWithLocation
  }
  
  var coordinate: CLLocationCoordinate2D {
    get {
      return placeWithLocation.location
    }
  }

  @objc var title: String? {
    get {
      return placeWithLocation.locationSearchEntry.terms.map{$0.value}.joinWithSeparator(", ")
    }
  }

}