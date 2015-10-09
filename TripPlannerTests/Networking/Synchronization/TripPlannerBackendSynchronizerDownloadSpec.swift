//
//  TripPlannerBackendSynchronizationSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 9/9/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Quick
import Nimble
import CoreLocation

@testable import TripPlanner

class TripPlannerBackendSynchronizerDownloadSpec: QuickSpec {
  
  override func spec() {
    
    describe("TripPlannerBackendSynchronizer") {
      var tripPlannerSynchronizer: TripPlannerBackendSynchronizer!
      
      context("downloadSync") {
        it("calls the TripPlannerClient to trigger an API Request") {
          let stack = CoreDataStack(stackType: .InMemory)
          let client = CoreDataClient(stack: stack)
          
          class TripPlannerClientMock: TripPlannerClient {
            var called = false
            
            override func fetchTrips(callback: FetchTripsCallback) {
              called = true
            }
          }
          
          let tripPlannerClientMock = TripPlannerClientMock()
          tripPlannerSynchronizer = TripPlannerBackendSynchronizer(tripPlannerClient: tripPlannerClientMock, coreDataClient: client)
          tripPlannerSynchronizer.downloadSync {}
          
          expect(tripPlannerClientMock.called).to(beTrue())
        }
        
        it("persists the received trips") {
          let stack = CoreDataStack(stackType: .InMemory)
          let client = CoreDataClient(stack: stack)
          
          class TripPlannerClientStub: TripPlannerClient {
            override func fetchTrips(callback: FetchTripsCallback) {
              let waypoint = JSONWaypoint(
                location: CLLocationCoordinate2D(latitude: 48.77855, longitude: 9.1799111),
                name: "Schlossplatz",
                serverID: "1"
              )
            
              let trip = JSONTrip(location: nil, locationDescription: "Stuttgart", waypoints: [waypoint], serverID: "55f0cbb4236f44b7f0e3cb23", lastUpdate: 10)
              let returnedTrips = [trip]
              
              callback(.Success(returnedTrips))
            }
          }
          
          let tripPlannerClientStub = TripPlannerClientStub()
          tripPlannerSynchronizer = TripPlannerBackendSynchronizer(tripPlannerClient: tripPlannerClientStub, coreDataClient: client)
          
          tripPlannerSynchronizer.downloadSync {}
          
          let allTrips = client.allTrips()
          
          expect(allTrips.count).to(equal(1))
          expect(allTrips[0].locationDescription).to(equal("Stuttgart"))
          expect((allTrips[0].waypoints?.anyObject() as! Waypoint).name).to(equal("Schlossplatz"))
        }
        
        it ("updates existing trips instead of creating new ones") {
          let stack = CoreDataStack(stackType: .InMemory)
          let client = CoreDataClient(stack: stack)
          
          let (tripToStuttgart, temporaryContext) = client.createObjectInTemporaryContext(Trip.self)
          tripToStuttgart.parsing = true
          tripToStuttgart.locationDescription = "Stuttgart"
          tripToStuttgart.serverID = "55f0cbb4236f44b7f0e3cb23"
          
          let waypoint = Waypoint(context: temporaryContext)
          waypoint.parsing = true
          waypoint.location = CLLocationCoordinate2D(latitude: 48.77855, longitude: 9.1799111)
          waypoint.name = "Schlossplatz"
          waypoint.trip = tripToStuttgart
          waypoint.serverID = "1"
        
          try! temporaryContext.save()
          client.saveStack()
          tripToStuttgart.parsing = false
          waypoint.parsing = false
          
          class TripPlannerClientStub: TripPlannerClient {
            override func fetchTrips(callback: FetchTripsCallback) {
              let waypoint = JSONWaypoint(
                location: CLLocationCoordinate2D(latitude: 48.77855, longitude: 9.1799111),
                name: "Schlossplatz New",
                serverID: "1"
              )
    
              let trip = JSONTrip(location: nil, locationDescription: "Stuttgart New", waypoints: [waypoint], serverID: "55f0cbb4236f44b7f0e3cb23", lastUpdate: 10)
              let returnedTrips = [trip]
              
              callback(.Success(returnedTrips))
            }
          }
          
          let tripPlannerClientStub = TripPlannerClientStub()
          tripPlannerSynchronizer = TripPlannerBackendSynchronizer(tripPlannerClient: tripPlannerClientStub, coreDataClient: client)
          
          tripPlannerSynchronizer.downloadSync {}
          
          let allTrips = client.allTrips()
          expect(allTrips.count).to(equal(1))
          expect(allTrips[0].lastUpdate).to(equal(10))
          expect(allTrips[0].locationDescription).to(equal("Stuttgart New"))
          expect(allTrips[0].waypoints?.count).to(equal(1))
          expect((allTrips[0].waypoints?.anyObject() as! Waypoint).name).to(equal("Schlossplatz New"))
        }
        
        it("does not update a trip if the server delivers outdated data") {
          let stack = CoreDataStack(stackType: .InMemory)
          let client = CoreDataClient(stack: stack)
          
          let (tripToStuttgart, temporaryContext) = client.createObjectInTemporaryContext(Trip.self)
          tripToStuttgart.locationDescription = "Stuttgart"
          tripToStuttgart.serverID = "55f0cbb4236f44b7f0e3cb23"
          // set lastUpdate timestamp higher than server one
          tripToStuttgart.lastUpdate = 100
          
          let waypoint = Waypoint(context: temporaryContext)
          waypoint.location = CLLocationCoordinate2D(latitude: 48.77855, longitude: 9.1799111)
          waypoint.name = "Schlossplatz"
          waypoint.trip = tripToStuttgart
          
          try! temporaryContext.save()
          client.saveStack()
          
          class TripPlannerClientStub: TripPlannerClient {
            override func fetchTrips(callback: FetchTripsCallback) {
              let waypoint = JSONWaypoint(
                location: CLLocationCoordinate2D(latitude: 48.77855, longitude: 9.1799111),
                name: "Schlossplatz New",
                serverID: "1"
              )
              let trip = JSONTrip(location: nil, locationDescription: "Stuttgart New", waypoints: [waypoint], serverID: "55f0cbb4236f44b7f0e3cb23", lastUpdate: 10)
              let returnedTrips = [trip]
              
              callback(.Success(returnedTrips))
            }
          }
          
          let tripPlannerClientStub = TripPlannerClientStub()
          tripPlannerSynchronizer = TripPlannerBackendSynchronizer(tripPlannerClient: tripPlannerClientStub, coreDataClient: client)
          
          tripPlannerSynchronizer.downloadSync {}
          
          let allTrips = client.allTrips()
          expect(allTrips.count).to(equal(1))
          expect(allTrips[0].locationDescription).to(equal("Stuttgart"))
          expect(allTrips[0].waypoints?.count).to(equal(1))
          expect((allTrips[0].waypoints?.anyObject() as! Waypoint).name).to(equal("Schlossplatz"))
        }
        
      }
      
      it("Deletes trips that exist locally but not on the server") {
        let stack = CoreDataStack(stackType: .InMemory)
        let client = CoreDataClient(stack: stack)
        
        let (tripToStuttgart, temporaryContext) = client.createObjectInTemporaryContext(Trip.self)
        tripToStuttgart.locationDescription = "Stuttgart"
        tripToStuttgart.serverID = "55f0cbb4236f44b7f0e3cb23"
        // set lastUpdate timestamp higher than server one
        tripToStuttgart.lastUpdate = 100
        
        let waypoint = Waypoint(context: temporaryContext)
        waypoint.location = CLLocationCoordinate2D(latitude: 48.77855, longitude: 9.1799111)
        waypoint.name = "Schlossplatz"
        waypoint.trip = tripToStuttgart
        
        try! temporaryContext.save()
        client.saveStack()
        
        class TripPlannerClientStub: TripPlannerClient {
          override func fetchTrips(callback: FetchTripsCallback) {
            // return empty result
            callback(.Success([]))
          }
        }
        
        let tripPlannerClientStub = TripPlannerClientStub()
        tripPlannerSynchronizer = TripPlannerBackendSynchronizer(tripPlannerClient: tripPlannerClientStub, coreDataClient: client)
        
        tripPlannerSynchronizer.downloadSync {}
        let allTrips = client.allTrips()
        let allWaypoints = client.allWaypoints()
        expect(allTrips.count).to(equal(0))
        expect(allWaypoints.count).to(equal(0))
      }
      
    }
  }
}
