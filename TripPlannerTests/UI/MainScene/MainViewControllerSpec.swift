//
//  MainViewControllerSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/21/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import Quick
import Nimble
import UIKit
import CoreData

@testable import TripPlanner

class MainViewControllerSpec: QuickSpec {
  
  override func spec() {
    
    describe("MainViewController") {
      var mainViewController: MainViewController!
      var stack: CoreDataStack!
      
      beforeEach {
        mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        // force view to be loaded, so we can check for outlets
        let _ = mainViewController.view
        
        stack = CoreDataStack(stackType: .InMemory)
      }
      
      describe("after loading") {
        it("has outlets set up correctly") {
          expect(mainViewController.tableView).notTo(beNil())
        }
      }
      
      describe("when its view appears") {
        
        it("accesses the trips stored in core data") {
          
          class CoreDataClientMock: CoreDataClient {
            var called = false
            
            override func allTrips() -> [Trip] {
              called = true
              return []
            }
          }
          
          let coreDataClientMock = CoreDataClientMock(stack: stack)
          
          mainViewController.coreDataClient = coreDataClientMock
          
          mainViewController.viewWillAppear(false)
          expect(coreDataClientMock.called).to(beTrue())
        }
        
        it("table view data source serves trips retrieved from core data") {

          class CoreDataClientStub: CoreDataClient {
                override func allTrips() -> [Trip] {
                    let trip1 = Trip(context: context)
                    trip1.locationDescription = "San Francisco"
                    
                    let trip2 = Trip(context: context)
                    trip2.locationDescription = "New York"
                    
                    return [trip1, trip2]
                }
            }
            
            let coreDataClientMock = CoreDataClientStub(stack: stack)
            mainViewController.coreDataClient = coreDataClientMock
            
            mainViewController.viewWillAppear(false)
            
            let cell = mainViewController.tableView.dataSource?.tableView(mainViewController.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! TripMainTableViewCell
            
            expect(cell.destinationLabel.text).to(equal("San Francisco"))
        }
      }
      
      describe("when add trip button is tapped") {
        
        it("creates a new trip in a temporary core data context") {
          
          class CoreDataClientMock: CoreDataClient {
            var called = false
            
            override func createObjectInTemporaryContext<T: TripPlannerManagedObject>(object: T.Type) -> (T, NSManagedObjectContext) {
              let childContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)

              if (object == Trip.self) {
                called = true
              }
              return (object.init(context: stack.managedObjectContext), childContext)
            }
          }
          
          let coreDataClientMock = CoreDataClientMock(stack: stack)
          mainViewController.coreDataClient = coreDataClientMock
          
          mainViewController.viewWillAppear(false)
          
          mainViewController.performSegueWithIdentifier("AddNewTrip", sender: self)
          
          expect(coreDataClientMock.called).to(beTrue())
        }
        
      }
      
      describe("when save trip exit segue is triggered after add button is tapped") {
        
        it("persists the newly created trip when the 'save' exit segue is called") {
          let coreDataClient = CoreDataClient(stack: stack)
          mainViewController.coreDataClient = coreDataClient

          mainViewController.viewWillAppear(false)
          
          mainViewController.performSegueWithIdentifier("AddNewTrip", sender: self)
          mainViewController.saveTrip(UIStoryboardSegue(identifier: "ExitSegue", source: UIViewController(), destination: UIViewController()))
          
          expect(coreDataClient.allTrips().count).to(equal(1))
        }
        
        it("does not persist the trip when 'cancel' segue is called") {
          let coreDataClient = CoreDataClient(stack: stack)
          mainViewController.coreDataClient = coreDataClient
          
          mainViewController.viewWillAppear(false)
          
          mainViewController.performSegueWithIdentifier("AddNewTrip", sender: self)
          mainViewController.cancelTripCreation((UIStoryboardSegue(identifier: "ExitSegue", source: UIViewController(), destination: UIViewController())))
          
          expect(coreDataClient.allTrips().count).to(equal(0))
        }
        
        it("discards previous trips successfully") {
          let coreDataClient = CoreDataClient(stack: stack)
          mainViewController.coreDataClient = coreDataClient
          
          mainViewController.viewWillAppear(false)
          
          // one trip is discarded
          mainViewController.performSegueWithIdentifier("AddNewTrip", sender: self)
          mainViewController.cancelTripCreation((UIStoryboardSegue(identifier: "ExitSegue", source: UIViewController(), destination: UIViewController())))
          
          // the other trip is saved
          mainViewController.performSegueWithIdentifier("AddNewTrip", sender: self)
          mainViewController.saveTrip(UIStoryboardSegue(identifier: "ExitSegue", source: UIViewController(), destination: UIViewController()))
          
          expect(coreDataClient.allTrips().count).to(equal(1))
        }
        
        it("discards previous trips successfully") {
          let coreDataClient = CoreDataClient(stack: stack)
          mainViewController.coreDataClient = coreDataClient
          
          mainViewController.viewWillAppear(false)
          
          // one trip is discarded
          mainViewController.performSegueWithIdentifier("AddNewTrip", sender: self)
          mainViewController.cancelTripCreation((UIStoryboardSegue(identifier: "ExitSegue", source: UIViewController(), destination: UIViewController())))
          
          // save exit segue is called immediately afterwards (technically not possible with current UI setup)
          mainViewController.saveTrip(UIStoryboardSegue(identifier: "ExitSegue", source: UIViewController(), destination: UIViewController()))
          
          expect(coreDataClient.allTrips().count).to(equal(0))
        }
        
      }

    }
    
    
  }

  
}