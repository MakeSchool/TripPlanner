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
  
  static let baseURL = "http://127.0.0.1:5000/"
 
  let urlSession: NSURLSession
  
  init(urlSession: NSURLSession = NSURLSession.sharedSession()) {
    self.urlSession = urlSession
  }
  
  func fetchTrips(callback: FetchTripsCallback) {
    let resource: Resource<[JSONTrip]> = Resource(
      baseURL: TripPlannerClient.baseURL,
      path: "trip/",
      queryString: nil,
      method: .GET,
      requestBody: nil,
      headers: ["Authorization": BasicAuth.generateBasicAuthHeader("user", password: "password")],
      parse: parse
    )
    
    let client = HTTPClient()
    client.apiRequest(self.urlSession, resource: resource, failure: { (reason: Reason, data: NSData?) -> () in
      dispatch_async(dispatch_get_main_queue()) {
        callback(.Failure(reason))
      }
      }) { (trips: [JSONTrip]) in
        dispatch_async(dispatch_get_main_queue()) {
          callback(.Success(trips))
        }
    }
  }
  
}