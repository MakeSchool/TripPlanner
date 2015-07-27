//
//  LocationSearch.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/23/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

typealias LocationSearchCallback = LocationSearchResult -> Void
typealias PlacesDetailsCallback = PlacesDetailsResult -> Void

enum LocationSearchResult {
  case Success(Predictions)
  case Error(NSError)
}

enum PlacesDetailsResult {
  case Success(PlaceDetails)
  case Error(NSError)
}

struct LocationSearch {
  
  let apiKey = "AIzaSyD5SSXNsZGmYd3gW76c1tB_EUryBZhFZq8"
  let urlSession: NSURLSession
  
  init(urlSession: NSURLSession = NSURLSession.sharedSession()) {
    self.urlSession = urlSession
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
      
    }) { (predictions: Predictions) in
      dispatch_async(dispatch_get_main_queue()) {
        callback(.Success(predictions))
      }
    }
  }
  
  func detailsForPlace(place: LocationSearchEntry, callback: PlacesDetailsCallback) {
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
  
    client.apiRequest(resource: resource, failure: { (reason: Reason, data: NSData?) -> () in
      
      }) { (details: PlaceDetails) in
        dispatch_async(dispatch_get_main_queue()) {
          callback(.Success(details))
        }
    }
  }
  
}