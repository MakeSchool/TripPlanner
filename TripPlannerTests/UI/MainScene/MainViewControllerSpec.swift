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
      }
    }
    
  }

  
}