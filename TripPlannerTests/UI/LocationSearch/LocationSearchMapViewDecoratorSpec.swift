//
//  LocationSearchMapViewDecoratorSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/28/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import Quick
import Nimble
import UIKit
import MapKit

@testable import TripPlanner

class LocationSearchMapViewDecoratorSpec: QuickSpec {
  
  override func spec() {
    
    describe("LocationSearchMapViewDecorator") {
      describe("displayedLocation") {
        
        it("highlights the selected location on the map") {
          class MockMapView: MKMapView {
            var addedAnnotation: MKAnnotation?
            var setRegionCalled = false
            
            override func addAnnotation(annotation: MKAnnotation) {
              addedAnnotation = annotation
            }
            
            override func setRegion(region: MKCoordinateRegion, animated: Bool) {
              setRegionCalled = true
            }
          }
          
          let mockMapView = MockMapView()
          let place = Place(description: "", id: "", matchedSubstrings: [], placeId: "", reference: "", terms: [], types: [])
          let coordinates = CLLocationCoordinate2D(latitude: 20, longitude: 10)
          let placeWithLocation = PlaceWithLocation(locationSearchEntry: place, location: coordinates)
          let locationSearchMapViewDecorator = LocationSearchMapViewDecorator(mapView: mockMapView)
          
          locationSearchMapViewDecorator.displayedLocation = placeWithLocation
          
          expect(mockMapView.addedAnnotation!.coordinate.latitude).to(equal(20))
          expect(mockMapView.addedAnnotation!.coordinate.longitude).to(equal(10))
          expect(mockMapView.setRegionCalled).to(beTrue())
        }
      }
    }
  }
}
