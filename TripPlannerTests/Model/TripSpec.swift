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
        
        it("updates to current timestamp when a trip is changed & saved") {
          let (trip, temporaryContext) = coreDataClient.createObjectInTemporaryContext(Trip.self)
          trip.lastUpdate = 0
          trip.locationDescription = "Test"
          try! temporaryContext.save()
          coreDataClient.saveStack()
          
          expect(trip.lastUpdate).to(beCloseTo(NSDate.timeIntervalSinceReferenceDate(), within: 2.0))
        }
        
      }
      
    }
  }
  
}