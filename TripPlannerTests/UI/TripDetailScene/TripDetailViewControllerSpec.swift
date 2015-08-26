//
//  TripDetailViewControllerSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/30/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

import Quick
import Nimble
import UIKit
import CoreData

@testable import TripPlanner

class TripDetailViewControllerSpec: QuickSpec {
  
  override func spec() {
    
    describe("TripDetailViewController") {
      var tripDetailViewController: TripDetailViewController!
      var stack: CoreDataStack!

      beforeEach {
        tripDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TripDetailViewController") as! TripDetailViewController
        // force view to be loaded, so we can check for outlets
        let _ = tripDetailViewController.view
        
        stack = CoreDataStack(stackType: .InMemory)
      }
      
      // MARK: Main View
      
      describe("Main view") {
        
        var trip: Trip!
        var coreDataClient: CoreDataClient!
        
        beforeEach {
          coreDataClient = CoreDataClient(stack: stack)
          tripDetailViewController.coreDataClient = coreDataClient
          
          // create trip
          trip = Trip(context: coreDataClient.context)
          trip.locationDescription = "San Francisco"
          stack.save()
          tripDetailViewController.trip = trip
        }
        
        context("when a trip has no waypoints") {
          
          it("displays the 'No Waypoints' view") {
            tripDetailViewController.viewWillAppear(false)
            
            expect(tripDetailViewController.view.subviews.contains(tripDetailViewController.noWayPointsView)).to(beTrue())
          }
          
        }
        
        context("when a trip has waypoints") {
          
          it("displays the 'list of waypoints' view") {
            // create waypoint
            let waypoint = Waypoint(context: coreDataClient.context)
            trip.addObject(waypoint, forKey: "waypoints")
            stack.save()
            
            tripDetailViewController.viewWillAppear(false)
            
            expect(tripDetailViewController.view.subviews.contains(tripDetailViewController.someWayPointsView)).to(beTrue())
          }
          
          it("triggers segue when a waypoint is selected") {
            // create waypoint
            let waypoint = Waypoint(context: coreDataClient.context)
            trip.addObject(waypoint, forKey: "waypoints")
            stack.save()
            
            class TripDetailViewControllerMock: TripDetailViewController {
              var segueIdentifier: String? = nil
              
              private override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
                segueIdentifier = identifier
              }
            }
            
            let mockTripDetailViewController = TripDetailViewControllerMock()
            mockTripDetailViewController.trip = trip
            let _ = mockTripDetailViewController.view
            let tripDetailView = TripDetailView()
            tripDetailView.tableView = UITableView()
            mockTripDetailViewController.someWayPointsView = tripDetailView
            mockTripDetailViewController.viewWillAppear(false)
            mockTripDetailViewController.tripDetailView(tripDetailView, selectedWaypoint: waypoint)
            
            expect(mockTripDetailViewController.segueIdentifier).to(equal("ShowWaypointDetails"))
          }
          
          it("assigns a waypoint to the TripDetailView when detail segue is trigerred") {
            // create waypoint
            let waypoint = Waypoint(context: coreDataClient.context)
            trip.addObject(waypoint, forKey: "waypoints")
            stack.save()
            
            let tripDetailView = TripDetailView()
            tripDetailViewController.activeView = tripDetailView
            tripDetailView.delegate = tripDetailViewController
            
            tripDetailViewController.tripDetailView(tripDetailView, selectedWaypoint: waypoint)
            
//            expect(tripDetailView.)
          }
          
        }
        
      }
      
      //MARK: Add Trip Button is Tapped
      
      describe("when add waypoint button is tapped") {
        
        it("creates a new waypoint in a temporary core data context") {
          
          class CoreDataClientMock: CoreDataClient {
            var called = false
            
            override func createObjectInTemporaryContext<T: TripPlannerManagedObject>(object: T.Type) -> (T, NSManagedObjectContext) {
              let childContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
              
              if (object == Waypoint.self) {
                called = true
              }
              return (object.init(context: stack.managedObjectContext), childContext)
            }
          }
          
          let coreDataClientMock = CoreDataClientMock(stack: stack)
          tripDetailViewController.coreDataClient = coreDataClientMock
          tripDetailViewController.trip = Trip(context: stack.managedObjectContext)
          
          tripDetailViewController.viewWillAppear(false)
          //TODO: look into getting segue from Storyboard instead of instantiating it here
          tripDetailViewController.performSegueWithIdentifier(Storyboard.Main.TripDetailViewController.Segues.AddWaypointSegue, sender: self)
          
          expect(coreDataClientMock.called).to(beTrue())
        }
        
      }
      
      describe("when waypoint exit segue is triggered after add button is tapped") {
        beforeEach {
          let coreDataClient = CoreDataClient(stack: stack)
          tripDetailViewController.coreDataClient = coreDataClient
          
          // create trip
          let trip = Trip(context: coreDataClient.context)
          trip.locationDescription = "San Francisco"
          stack.save()
          tripDetailViewController.trip = trip
          
          tripDetailViewController.viewWillAppear(false)
          
          tripDetailViewController.performSegueWithIdentifier(Storyboard.Main.TripDetailViewController.Segues.AddWaypointSegue, sender: self)
        }
        
        it("persists the newly created waypoint when 'save' segue is called") {
          tripDetailViewController.saveWaypoint(UIStoryboardSegue(identifier: Storyboard.UnwindSegues.ExitSaveWaypointSegue, source: UIViewController(), destination: UIViewController()))
          
          let waypointForTrips = tripDetailViewController.trip!.waypoints!.count
          expect(waypointForTrips).to(equal(1))
        }
        
        it("does not persist the waypoint when 'cancel' segue is called") {
          tripDetailViewController.cancelWaypointCreation(UIStoryboardSegue(identifier: Storyboard.UnwindSegues.ExitCancelWaypointSegue, source: UIViewController(), destination: UIViewController()))
          
          let waypointForTrips = tripDetailViewController.trip!.waypoints!.count
          expect(waypointForTrips).to(equal(0))
        }
      }
      
      describe("when multiple waypoints are added and multiple exit segues are called") {
        beforeEach {
          let coreDataClient = CoreDataClient(stack: stack)
          tripDetailViewController.coreDataClient = coreDataClient
          
          // create trip
          let trip = Trip(context: coreDataClient.context)
          trip.locationDescription = "San Francisco"
          stack.save()
          tripDetailViewController.trip = trip
          
          tripDetailViewController.viewWillAppear(false)
        }
        
        it("discards unsaved waypoints successfully") {
          // one waypoint is discarded
          tripDetailViewController.performSegueWithIdentifier(Storyboard.Main.TripDetailViewController.Segues.AddWaypointSegue, sender: self)
          tripDetailViewController.cancelWaypointCreation(UIStoryboardSegue(identifier: Storyboard.UnwindSegues.ExitCancelWaypointSegue, source: UIViewController(), destination: UIViewController()))
          
          // a second waypoint is saved
          tripDetailViewController.performSegueWithIdentifier(Storyboard.Main.TripDetailViewController.Segues.AddWaypointSegue, sender: self)
          tripDetailViewController.saveWaypoint(UIStoryboardSegue(identifier: Storyboard.UnwindSegues.ExitSaveWaypointSegue, source: UIViewController(), destination: UIViewController()))
          
          let waypointForTrips = tripDetailViewController.trip!.waypoints!.count
          expect(waypointForTrips).to(equal(1))
        }
        
        it("discards unsaved waypoints as soon as cancel segue is performed") {
          // one waypoint is discarded
          tripDetailViewController.performSegueWithIdentifier(Storyboard.Main.TripDetailViewController.Segues.AddWaypointSegue, sender: self)
          tripDetailViewController.cancelWaypointCreation(UIStoryboardSegue(identifier: Storyboard.UnwindSegues.ExitCancelWaypointSegue, source: UIViewController(), destination: UIViewController()))
          
          // save exit segue is called immediately afterwards (technically not possible with current UI setup)
          tripDetailViewController.saveWaypoint(UIStoryboardSegue(identifier: Storyboard.UnwindSegues.ExitSaveWaypointSegue, source: UIViewController(), destination: UIViewController()))
          
          let waypointForTrips = tripDetailViewController.trip!.waypoints!.count
          expect(waypointForTrips).to(equal(0))
        }
      }
      
    }
    
  }
  
}