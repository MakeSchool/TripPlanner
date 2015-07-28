//
//  LocationSearch.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/23/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreLocation
import Result

typealias LocationSearchCallback = Result<Predictions, Reason> -> Void
typealias PlacesDetailsCallback = Result<PlaceWithLocation, Reason> -> Void

struct LocationSearch {
  
  private var apiKey = ""
  let urlSession: NSURLSession
  
  init(urlSession: NSURLSession = NSURLSession.sharedSession(), apiKey: String = "") {
    self.urlSession = urlSession
    self.apiKey = apiKey
  }
    
  func findPlaces(searchString: String, callback: LocationSearchCallback) {
    let resource: Resource<Predictions> = Resource(
      baseURL:"https://maps.googleapis.com",
      path: "maps/api/place/autocomplete/json",
      queryString: "input=\(HTTPClient.escape(searchString))&key=\(apiKey)",
      method: .GET,
      requestBody: nil,
      headers: nil,
      parse: parse
    )
    
    let client = HTTPClient()
    client.apiRequest(self.urlSession, resource: resource, failure: { (reason: Reason, data: NSData?) -> () in
      dispatch_async(dispatch_get_main_queue()) {
        callback(.Failure(reason))
      }
    }) { (predictions: Predictions) in
      dispatch_async(dispatch_get_main_queue()) {
        callback(.Success(predictions))
      }
    }
  }
  
  func detailsForPlace(place: Place, callback: PlacesDetailsCallback) {
    let resource: Resource<PlaceDetails> = Resource(
      baseURL:"https://maps.googleapis.com",
      path: "maps/api/place/details/json",
      queryString: "placeid=\(HTTPClient.escape(place.placeId))&key=\(apiKey)",
      method: .GET,
      requestBody: nil,
      headers: nil,
      parse: parse
    )
    
    let client = HTTPClient()
  
    client.apiRequest(self.urlSession, resource: resource, failure: { (reason: Reason, data: NSData?) -> () in
      dispatch_async(dispatch_get_main_queue()) {
        callback(.Failure(reason))
      }
    }) { (details: PlaceDetails) in
      dispatch_async(dispatch_get_main_queue()) {
        let latitude = details.result.geometry.location.latitude;
        let longitude = details.result.geometry.location.longitude;
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        let placeWithLocation = PlaceWithLocation(locationSearchEntry: place, location: location)
        callback(.Success(placeWithLocation))
      }
    }
  }
  
}