//
//  TripPlannerClient.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 9/7/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import Result
import CoreLocation

typealias FetchTripsCallback = Result<[JSONTrip], Reason> -> Void

class TripPlannerClient {
 
  private var apiKey = ""
  let urlSession: NSURLSession
  
  init(urlSession: NSURLSession = NSURLSession.sharedSession(), apiKey: String = "") {
    self.urlSession = urlSession
    self.apiKey = apiKey
  }
  
  func fetchTrips(callback: FetchTripsCallback) {
    let waypoints = [JSONWaypoint(location: CLLocationCoordinate2D(), name: "Schlossplatz")]
    let trip = JSONTrip(location: CLLocationCoordinate2D(), locationDescription: "Stuttgart", waypoints: waypoints)
    
    callback(.Success([trip]))
  }
  
}