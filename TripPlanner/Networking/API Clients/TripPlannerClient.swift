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
typealias UploadTripCallback = Result<JSONTrip, Reason> -> Void
typealias UpdateTripCallback = Result<JSONTrip, Reason> -> Void
typealias DeleteTripCallback = Result<JSONTripDeletionResponse, Reason> -> Void

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
  
  func createDeleteTripRequest(tripServerID: TripServerID) -> TripPlannerClientDeleteTripRequest {
    let resource: Resource<JSONTripDeletionResponse> = Resource(
      baseURL: TripPlannerClient.baseURL,
      path: "trip/\(tripServerID)",
      queryString: nil,
      method: .DELETE,
      requestBody: nil,
      headers: ["Authorization": BasicAuth.generateBasicAuthHeader("user", password: "password")],
      parse: parse
    )

    return TripPlannerClientDeleteTripRequest(resource: resource, tripServerID: tripServerID)
  }
  
  func createUpdateTripRequest(trip: Trip) -> TripPlannerClientUpdateTripRequest {
    let resource: Resource<JSONTrip> = Resource(
      baseURL: TripPlannerClient.baseURL,
      path: "trip/\(trip.serverID)",
      queryString: nil,
      method: .PUT,
      requestBody: JSONEncoding.encodeJSONTrip(trip),
      headers: ["Authorization": BasicAuth.generateBasicAuthHeader("user", password: "password")],
      parse: parse
    )
    
    return TripPlannerClientUpdateTripRequest(resource: resource, trip: trip)
  }
  
  func createCreateTripRequest(trip: Trip) -> TripPlannerClientCreateTripRequest {
    let resource: Resource<JSONTrip> = Resource(
      baseURL: TripPlannerClient.baseURL,
      path: "trip/",
      queryString: nil,
      method: .POST,
      requestBody: JSONEncoding.encodeJSONTrip(trip),
      headers: ["Authorization": BasicAuth.generateBasicAuthHeader("user", password: "password"), "Content-Type": "application/json"],
      parse: parse
    )
    
    return TripPlannerClientCreateTripRequest(resource: resource, trip: trip)
  }
  
}

// TODO: reduce redundancy

class TripPlannerClientDeleteTripRequest {
  var resource: Resource<JSONTripDeletionResponse>
  var tripServerID: TripServerID
  
  required init(resource: Resource<JSONTripDeletionResponse>, tripServerID: TripServerID) {
    self.resource = resource
    self.tripServerID = tripServerID
  }
  
  func perform(urlSession: NSURLSession, callback: DeleteTripCallback) {
    let client = HTTPClient()
    client.apiRequest(urlSession, resource: resource, failure: { (reason: Reason, data: NSData?) -> () in
      dispatch_async(dispatch_get_main_queue()) {
        callback(.Failure(reason))
      }
      }) { (deletedTripResponse: JSONTripDeletionResponse) in
        dispatch_async(dispatch_get_main_queue()) {
          callback(.Success(deletedTripResponse))
        }
    }
  }
}

class TripPlannerClientCreateTripRequest {
  var resource: Resource<JSONTrip>
  var trip: Trip
  
  required init(resource: Resource<JSONTrip>, trip: Trip) {
    self.resource = resource
    self.trip = trip
  }
  
  func perform(urlSession: NSURLSession, callback: UploadTripCallback) {
    let client = HTTPClient()
    client.apiRequest(urlSession, resource: resource, failure: { (reason: Reason, data: NSData?) -> () in
      dispatch_async(dispatch_get_main_queue()) {
        callback(.Failure(reason))
      }
      }) { (uploadedTrip: JSONTrip) in
        dispatch_async(dispatch_get_main_queue()) {
          callback(.Success(uploadedTrip))
        }
    }
  }
}

class TripPlannerClientUpdateTripRequest {
  var resource: Resource<JSONTrip>
  var trip: Trip
  
  required init(resource: Resource<JSONTrip>, trip: Trip) {
    self.resource = resource
    self.trip = trip
  }
  
  func perform(urlSession: NSURLSession, callback: UpdateTripCallback) {
    let client = HTTPClient()
    client.apiRequest(urlSession, resource: resource, failure: { (reason: Reason, data: NSData?) -> () in
      dispatch_async(dispatch_get_main_queue()) {
        callback(.Failure(reason))
      }
      }) { (updatedTrip: JSONTrip) in
        dispatch_async(dispatch_get_main_queue()) {
          callback(.Success(updatedTrip))
        }
    }
  }
}