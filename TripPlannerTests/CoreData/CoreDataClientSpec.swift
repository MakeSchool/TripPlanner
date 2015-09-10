//
//  CoreDataClientSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/23/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import Quick
import Nimble
import CoreData
@testable import TripPlanner

class CoreDataClientSpec: QuickSpec {
  
  override func spec() {
    describe("CoreDataClient") {
      
      var coreDataStack: CoreDataStack!
      var coreDataClient: CoreDataClient!
      
      beforeEach {
        coreDataStack = CoreDataStack(stackType: .InMemory)
        coreDataClient = CoreDataClient(stack: coreDataStack)
      }
      
      describe("allTrips") {
        
        it("returns all trips stored in the context") {
          let _ = Trip(context: coreDataClient.context)
          let _ = Trip(context: coreDataClient.context)
          
          coreDataClient.saveStack()
          
          let allTrips = coreDataClient.allTrips()
          expect(allTrips.count).to(equal(2))
        }
        
      }
      
      describe("tripWithServerID") {
        
        it("returns trips matching provided server identifier") {
          let trip = Trip(context: coreDataClient.context)
          trip.serverID = "0"
          
          coreDataClient.saveStack()

          let receivedTrip = coreDataClient.tripWithServerID("0")
          
          expect(receivedTrip).toNot(beNil())
          expect(receivedTrip!.serverID).to(equal(trip.serverID))
        }
        
      }
      
      describe("createObjectInTemporaryContext(_:)") {
        
        it("returns an instance that lives in a core data context that has a parent context") {
          let (newObject, temporaryContext) = coreDataClient.createObjectInTemporaryContext(Trip.self)
          
          expect(newObject.managedObjectContext).to(equal(temporaryContext))
          expect(temporaryContext.parentContext).to(equal(coreDataClient.context))
        }
        
      }
      
      describe("saveStack") {
    
        it("calls save on the underlying core data stack") {
          class CoreDataStackMock: CoreDataStack {
            var called = false
            override func save() {
              called = true
            }
          }
  
          let coreDataStackMock = CoreDataStackMock(stackType: .InMemory)
          let coreDataClient = CoreDataClient(stack: coreDataStackMock)
          
          coreDataClient.saveStack()

          expect(coreDataStackMock.called).to(beTrue())
        }
        
      }
      
    }
  }
}
