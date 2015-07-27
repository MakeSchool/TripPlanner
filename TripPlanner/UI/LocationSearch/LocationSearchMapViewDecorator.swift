//
//  LocationSearchMapViewDecorator.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/27/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import MapKit

class LocationSearchMapViewDecorator {
  
  let mapView: MKMapView
  var displayedLocation: LocationSearchEntry? {
    didSet {
      
    }
  }
  
  init(mapView: MKMapView) {
    self.mapView = mapView
  }
  
}