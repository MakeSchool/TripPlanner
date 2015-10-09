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
typealias UploadTripCallback = Result<[JSONTrip], Reason> -> Void
typealias UpdateTripCallback = Result<[JSONTrip], Reason> -> Void
typealias DeleteTripCallback = Result<[TripServerID], Reason> -> Void

protocol TripPlannerClientRequest {
  typealias CallbackType
  typealias ResourceType
  
  var resource: Resource<[ResourceType]> { get set }

  init(resource: Resource<[ResourceType]>)
  func perform(urlSession: NSURLSession, callback: CallbackType)
}

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
    let resource: Resource<[TripServerID]> = Resource(
      baseURL: TripPlannerClient.baseURL,
      path: "trip/\(tripServerID)",
      queryString: nil,
      method: .DELETE,
      requestBody: nil,
      headers: ["Authorization": BasicAuth.generateBasicAuthHeader("user", password: "password")],
      parse: parse
    )

    return TripPlannerClientDeleteTripRequest(resource: resource)
  }
  
  func createUpdateTripRequest(trip: Trip) -> TripPlannerClientUpdateTripRequest {
    let resource: Resource<[JSONTrip]> = Resource(
      baseURL: TripPlannerClient.baseURL,
      path: "trip/\(trip.serverID)",
      queryString: nil,
      method: .PUT,
      requestBody: JSONEncoding.encodeJSONTrip(trip),
      headers: ["Authorization": BasicAuth.generateBasicAuthHeader("user", password: "password")],
      parse: parse
    )
    
    return TripPlannerClientUpdateTripRequest(resource: resource)
  }
  
  func createCreateTripRequest(trip: Trip) -> TripPlannerClientCreateTripRequest {
    let resource: Resource<[JSONTrip]> = Resource(
      baseURL: TripPlannerClient.baseURL,
      path: "trip/",
      queryString: nil,
      method: .POST,
      requestBody: JSONEncoding.encodeJSONTrip(trip),
      headers: ["Authorization": BasicAuth.generateBasicAuthHeader("user", password: "password")],
      parse: parse
    )
    
    return TripPlannerClientCreateTripRequest(resource: resource)
  }
  
}

// TODO: reduce redundancy

class TripPlannerClientDeleteTripRequest: TripPlannerClientRequest {
  var resource: Resource<[TripServerID]>
  
  required init(resource: Resource<[TripServerID]>) {
    self.resource = resource
  }
  
  func perform(urlSession: NSURLSession, callback: DeleteTripCallback) {
    let client = HTTPClient()
    client.apiRequest(urlSession, resource: resource, failure: { (reason: Reason, data: NSData?) -> () in
      dispatch_async(dispatch_get_main_queue()) {
        callback(.Failure(reason))
      }
      }) { (deletedTrips: [TripServerID]) in
        dispatch_async(dispatch_get_main_queue()) {
          callback(.Success(deletedTrips))
        }
    }
  }
}

class TripPlannerClientCreateTripRequest: TripPlannerClientRequest {
  var resource: Resource<[JSONTrip]>
  
  required init(resource: Resource<[JSONTrip]>) {
    self.resource = resource
  }
  
  func perform(urlSession: NSURLSession, callback: UploadTripCallback) {
    let client = HTTPClient()
    client.apiRequest(urlSession, resource: resource, failure: { (reason: Reason, data: NSData?) -> () in
      dispatch_async(dispatch_get_main_queue()) {
        callback(.Failure(reason))
      }
      }) { (uploadedTrips: [JSONTrip]) in
        dispatch_async(dispatch_get_main_queue()) {
          callback(.Success(uploadedTrips))
        }
    }
  }
}

class TripPlannerClientUpdateTripRequest: TripPlannerClientRequest {
  var resource: Resource<[JSONTrip]>
  
  required init(resource: Resource<[JSONTrip]>) {
    self.resource = resource
  }
  
  func perform(urlSession: NSURLSession, callback: UpdateTripCallback) {
    let client = HTTPClient()
    client.apiRequest(urlSession, resource: resource, failure: { (reason: Reason, data: NSData?) -> () in
      dispatch_async(dispatch_get_main_queue()) {
        callback(.Failure(reason))
      }
      }) { (uploadedTrips: [JSONTrip]) in
        dispatch_async(dispatch_get_main_queue()) {
          callback(.Success(uploadedTrips))
        }
    }
  }
}