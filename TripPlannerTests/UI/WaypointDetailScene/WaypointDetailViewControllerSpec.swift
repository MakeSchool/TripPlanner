//
//  WaypointDetailViewControllerSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 8/7/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

import Quick
import Nimble
import UIKit
import CoreData

@testable import TripPlanner

class WaypointDetailViewControllerSpec: QuickSpec {
  
  override func spec() {
    
    describe("WaypointDetailViewController") {
      var waypointDetailViewController: WaypointDetailViewController!
      var stack: CoreDataStack!
      
      beforeEach {
        waypointDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WaypointDetailViewController") as! WaypointDetailViewController
        // force view to be loaded, so we can check for outlets
        let _ = waypointDetailViewController.view
        
        stack = CoreDataStack(stackType: .InMemory)
      }
      
      describe("IBOutlets") {
        
        it("has a MapView") {
          expect(waypointDetailViewController.mapView).notTo(beNil())
        }
        
      }
      
      describe("viewDidLoad") {
        
        it("sets up a MapViewDecorator") {
          expect(waypointDetailViewController.mapViewDecorator).notTo(beNil())
        }
        
      }
      
      describe("viewWillAppear") {
        
        it("updates the naviation item to reflect the selected location") {
          let waypoint = Waypoint(context: stack.managedObjectContext)
          waypoint.name = "Market Street, San Francisco"
          
          waypointDetailViewController.waypoint = waypoint
          waypointDetailViewController.viewWillAppear(false)
          
          expect(waypointDetailViewController.navigationItem.title).to(equal(waypoint.name))
        }
        
        it("highlights the selected location on the map") {
          class LocationSearchMapViewDecoratorMock: LocationSearchMapViewDecorator {
            var setWaypoint: Waypoint?
            
            override var displayedWaypoint: Waypoint? {
              didSet {
                setWaypoint = displayedWaypoint
              }
            }
          }
          
          let waypoint = Waypoint(context: stack.managedObjectContext)
          waypoint.name = "Market Street, San Francisco"
          waypoint.longitude = 10
          waypoint.latitude = 10
          
          let mockMapViewDecorator = LocationSearchMapViewDecoratorMock(mapView: waypointDetailViewController.mapView)
          
          waypointDetailViewController.mapViewDecorator = mockMapViewDecorator
          waypointDetailViewController.waypoint = waypoint
          waypointDetailViewController.viewWillAppear(false)

          expect(mockMapViewDecorator.setWaypoint).to(equal(waypoint))
        }
        
      }
      
    }
  }
}

