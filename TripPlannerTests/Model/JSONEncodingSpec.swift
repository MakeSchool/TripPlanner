//
//  JSONEncodingSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 10/8/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

import Quick
import Nimble
import CoreLocation

@testable import TripPlanner

class JSONEncodingSpec: QuickSpec {
  
  override func spec() {
    
    describe("JSONEncoding") {
      
      context("encodeJSONTrip") {
        
        it("generates valid and JSON that correctly represents the provided trip") {
          let stack = CoreDataStack(stackType: .InMemory)
          let client = CoreDataClient(stack: stack)
          
          let trip = Trip(context: client.context)
          trip.serverID = "10"
          
          let waypoint1 = Waypoint(context: client.context)
          waypoint1.location = CLLocationCoordinate2D(latitude: 30.8, longitude: 14.2)
          waypoint1.trip = trip
          
          let waypoint2 = Waypoint(context: client.context)
          waypoint2.location = CLLocationCoordinate2D(latitude: 30.8, longitude: 14.2)
          waypoint2.trip = trip
          
          client.saveStack()
          
          let jsonData = JSONEncoding.encodeJSONTrip(trip)
          
          let parsedTrip: JSONTrip = parse(jsonData)!
          
          expect(parsedTrip.serverID).to(equal("10"))
          expect(parsedTrip.waypoints.count).to(equal(2))
          expect(parsedTrip.waypoints[0].location.latitude).to(equal(30.8))
          expect(parsedTrip.waypoints[0].location.longitude).to(equal(14.2))
        }
        
      }
      
    }
    
  }
  
}

