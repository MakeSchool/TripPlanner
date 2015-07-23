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
          
          let coreDataClientMock = CoreDataClientMock(context: stack.managedObjectContext)
          
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
            
            let coreDataClientMock = CoreDataClientStub(context: stack.managedObjectContext)
            mainViewController.coreDataClient = coreDataClientMock
            
            mainViewController.viewWillAppear(true)
            
            let cell = mainViewController.tableView.dataSource?.tableView(mainViewController.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! TripMainTableViewCell
            
            expect(cell.destinationLabel.text).to(equal("San Francisco"))
        }
      }
      
      describe("when add trip button is tapped") {
        
        it("creates a new trip in a temporary core data context") {
          
          class CoreDataClientMock: CoreDataClient {
            var called = false
            
            override func createObjectInTemporaryContext<T: TripPlannerManagedObject>(object: T.Type) -> T {
              if (object == Trip.self) {
                called = true
              }
              return object.init(context: context)
            }
          }
          
          let coreDataClientMock = CoreDataClientMock(context: stack.managedObjectContext)
          mainViewController.coreDataClient = coreDataClientMock
          
          mainViewController.performSegueWithIdentifier("AddNewTrip", sender: self)
          
          expect(coreDataClientMock.called).to(beTrue())
        }
        
      }
      
      describe("when save trip exit segue is triggered after add button is tapped") {
        
        it("persists the newly created trip") {
          mainViewController.viewWillAppear(false)
          let coreDataClient = CoreDataClient(context: stack.managedObjectContext)
          mainViewController.coreDataClient = coreDataClient
          mainViewController.performSegueWithIdentifier("AddNewTrip", sender: self)
          mainViewController.saveTrip(UIStoryboardSegue(identifier: "ExitSegue", source: UIViewController(), destination: UIViewController()))
          
          expect(coreDataClient.allTrips().count).to(equal(1))
        }
        
      }

    }
    
    
  }

  
}