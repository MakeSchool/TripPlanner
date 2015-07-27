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
  var currentAnnotation: PlaceWithLocationAnnotation?
  
  var displayedLocation: PlaceWithLocation? {
    didSet {
      if let displayedLocation = displayedLocation {
        currentAnnotation = PlaceWithLocationAnnotation(placeWithLocation: displayedLocation)
        mapView.addAnnotation(currentAnnotation!)
        
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegion(center: displayedLocation.location, span: span)

        mapView.setRegion(region, animated: true)
      }
    }
  }
  
  init(mapView: MKMapView) {
    self.mapView = mapView
  }
  
}