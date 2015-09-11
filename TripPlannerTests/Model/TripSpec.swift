//
//  TripSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/20/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import Quick
import Nimble
import CoreData
@testable import TripPlanner

class TripSpec: QuickSpec {
  
  override func spec() {
    describe("Trip") {
      var coreDataStack: CoreDataStack!
      var coreDataClient: CoreDataClient!
      
      beforeEach {
        coreDataStack = CoreDataStack(stackType: .InMemory)
        coreDataClient = CoreDataClient(stack: coreDataStack)
      }
      
      describe("lastUpdated property") {
        
        var trip: Trip!
        var temporaryContext: NSManagedObjectContext!
        
        beforeEach {
          let (t, tempContext) = coreDataClient.createObjectInTemporaryContext(Trip.self)
          trip = t
          temporaryContext = tempContext
          
          trip.parsing = true
          trip.locationDescription = "Test"
          trip.lastUpdate = 0
          try! temporaryContext.save()
          coreDataClient.saveStack()
          trip.parsing = false
        }
        
        it("updates to current timestamp when a trip is changed & saved") {
          // trigger a relevant update before saving
          trip.locationDescription = "Updated"
          try! temporaryContext.save()
          coreDataClient.saveStack()
          
          expect(trip.lastUpdate).to(beCloseTo(NSDate.timeIntervalSinceReferenceDate(), within: 2.0))
        }
        
        it("does not update the timestamp when a trip is saved but not changed") {
          // do not trigger a relevant update before saving
          try! temporaryContext.save()
          coreDataClient.saveStack()
          
          expect(trip.lastUpdate).to(equal(0))
        }
        
      }
      
    }
  }
  
}