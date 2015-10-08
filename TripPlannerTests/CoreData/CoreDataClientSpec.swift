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
      
      describe("allWaypoints") {
        
        it("returns all waypoints") {
          let waypoint1 = Waypoint(context: coreDataClient.context)
          let waypoint2 = Waypoint(context: coreDataClient.context)
          
          coreDataClient.saveStack()
          
          let allWaypoints = coreDataClient.allWaypoints()
          expect(allWaypoints.count).to(equal(2))
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
      
      describe("waypointWithServerID") {
        
        it("returns waypoints matching provided server identifier") {
          let waypoint = Waypoint(context: coreDataClient.context)
          waypoint.serverID = "0"
          
          coreDataClient.saveStack()
          
          let receivedWaypoint = coreDataClient.waypointWithServerID("0")
          
          expect(receivedWaypoint).toNot(beNil())
          expect(receivedWaypoint!.serverID).to(equal(waypoint.serverID))
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
      
      describe("unsyncedTrips") {
        
        it("returns trips do not have a serverID") {
          let _ = Trip(context: coreDataClient.context)
          coreDataClient.saveStack()
          
          let receivedTrips = coreDataClient.unsyncedTrips()
          
          expect(receivedTrips.count).to(equal(1))
        }
        
      }
      
      describe("unsyncedTripDeletions") {
        
        it("returns all trip deletions that have not been synced yet") {
          let trip = Trip(context: coreDataClient.context)
          coreDataClient.saveStack()
          
          coreDataClient.markTripAsDeleted(trip)
          coreDataClient.saveStack()
          
          let tripsToBeDeleted = coreDataClient.unsyncedTripDeletions()
          
          expect(tripsToBeDeleted.count).to(equal(1))
        }
        
      }
      
      describe("tripsUpdatedSince:") {
        
        it("returns trips with a lastUpdate timestamp that is larger than N") {
          let trip = Trip(context: coreDataClient.context)
          trip.lastUpdate = 100
          coreDataClient.saveStack()
          
          let receivedTrips = coreDataClient.tripsThatChangedSince(10)
          
          expect(receivedTrips.count).to(equal(1))
        }
        
        it("returns trips with a lastUpdate timestamp that is smaller than N") {
          let trip = Trip(context: coreDataClient.context)
          trip.lastUpdate = 100
          // set to 'parsing' to avoid automatic update of 'lastUpdate' upon saving
          trip.parsing = true
          coreDataClient.saveStack()
          
          let receivedTrips = coreDataClient.tripsThatChangedSince(1000)
          
          expect(receivedTrips.count).to(equal(0))
        }
        
      }
      
    }
    
  }
}
