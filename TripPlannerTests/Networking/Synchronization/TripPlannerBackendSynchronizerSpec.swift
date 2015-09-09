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

class TripPlannerBackendSynchronizerSpec: QuickSpec {
    
    override func spec() {
        
        describe("TripPlannerBackendSynchronizer") {
            var tripPlannerSynchronizer: TripPlannerBackendSynchronizer!
            
            context("downloadSync") {
                it("calls the TripPlannerClient to trigger an API Request") {
                    class TripPlannerClientMock: TripPlannerClient {
                        var called = false
                        
                        override func fetchTrips(callback: FetchTripsCallback) {
                            called = true
                        }
                    }
                    
                    let tripPlannerClientMock = TripPlannerClientMock()
                    tripPlannerSynchronizer = TripPlannerBackendSynchronizer(tripPlannerClient: tripPlannerClientMock)
                    tripPlannerSynchronizer.downloadSync()
                    
                    expect(tripPlannerClientMock.called).to(beTrue())
                }
                
                it("persists the received trips") {
                    class TripPlannerClientStub: TripPlannerClient {
                        override func fetchTrips(callback: FetchTripsCallback) {
                            let waypoint = JSONWaypoint(location: CLLocationCoordinate2D(latitude: 48.77855, longitude: 9.1799111), name: "Schlossplatz")
                            let trip = JSONTrip(location: nil, locationDescription: "Stuttgart", waypoints: [waypoint])
                            let returnedTrips = [trip]
                            
                            callback(.Success(returnedTrips))
                        }
                    }
                    
                    let tripPlannerClientStub = TripPlannerClientStub()
                    tripPlannerSynchronizer = TripPlannerBackendSynchronizer(tripPlannerClient: tripPlannerClientStub)
                }
            }
            
        }
    }
}
