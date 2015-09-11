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
        var waypoint: Waypoint!
        var temporaryContext: NSManagedObjectContext!
        
        beforeEach {
          let (t, tempContext) = coreDataClient.createObjectInTemporaryContext(Trip.self)

          trip = t
          temporaryContext = tempContext
          
          trip.parsing = true
          trip.locationDescription = "Test"
          trip.lastUpdate = 0
          
          let w = Waypoint(context: tempContext)
          waypoint = w
          waypoint.name = "W"
          waypoint.trip = trip
          waypoint.parsing = true
          
          try! temporaryContext.save()
          coreDataClient.saveStack()
          trip.parsing = false
          waypoint.parsing = false
        }
        
        it("updates to current timestamp when a trip is changed & saved") {
          // trigger a relevant update before saving
          trip.locationDescription = "Updated"
          try! temporaryContext.save()
          coreDataClient.saveStack()
          
          expect(trip.lastUpdate).to(beCloseTo(NSDate.timeIntervalSinceReferenceDate(), within: 2.0))
        }
        
        it("updates to current timestamp when a waypoint that belongs to a trip is changed & saved") {
          // trigger a relevant update before saving
          waypoint.name = "New name"
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