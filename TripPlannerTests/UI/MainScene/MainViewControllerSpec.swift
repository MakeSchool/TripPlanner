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
@testable import TripPlanner

class MainViewControllerSpec: QuickSpec {
  
  override func spec() {
    
    describe("MainViewController") {
      var mainViewController: MainViewController!

      beforeEach {
        mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        // force view to be loaded, so we can check for outlets
        let _ = mainViewController.view
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
          
          let stack = CoreDataStack(stackType: .InMemory)
          let coreDataClientMock = CoreDataClientMock(context: stack.managedObjectContext)
          
          mainViewController.coreDataClient = coreDataClientMock
          
          mainViewController.viewWillAppear(true)
          expect(coreDataClientMock.called).to(beTrue())
        }
        
        it("table view data source serves trips retrieved from core data") {
            let stack = CoreDataStack(stackType: .InMemory)
            
            class CoreDataClientMock: CoreDataClient {
                
                override func allTrips() -> [Trip] {
                    let trip1 = Trip(context: context)
                    trip1.locationDescription = "San Francisco"
                    
                    let trip2 = Trip(context: context)
                    trip2.locationDescription = "New York"
                    
                    return [trip1, trip2]
                }
            }
            
            let coreDataClientMock = CoreDataClientMock(context: stack.managedObjectContext)
            mainViewController.coreDataClient = coreDataClientMock
            
            mainViewController.viewWillAppear(true)
            
            let cell = mainViewController.tableView.dataSource?.tableView(mainViewController.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! TripMainTableViewCell
            
            expect(cell.destinationLabel.text).to(equal("San Francisco"))
        }
      }
    }
    
  }

  
}