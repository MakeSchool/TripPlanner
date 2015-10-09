//
//  TripPlannerClientSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 9/7/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Quick
import Nimble
import DVR

@testable import TripPlanner

class TripPlannerClientSpec: QuickSpec {
  
  override func spec() {
    
    describe("TripPlannerClient") {
      var tripPlannerClient: TripPlannerClient!
      
      context("successful API requests") {
        beforeEach {
          let session = Session(cassetteName: "trip_planner_api", testBundle: NSBundle.mainBundle())
          tripPlannerClient = TripPlannerClient(urlSession: session)
        }
        
        describe("fetchTrips") {
          it("calls the callback with parsed data when the request is successful") {
            waitUntil {done in
              tripPlannerClient.fetchTrips { result in
                if case let .Success(trips) = result {
                  if (trips[0].locationDescription == "Stuttgart" && trips[0].waypoints[0].location.latitude == 9.1799111) {
                    done()
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}