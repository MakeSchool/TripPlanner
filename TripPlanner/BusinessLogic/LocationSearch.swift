//
//  LocationSearch.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/23/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

typealias LocationSearchCallback = LocationSearchResult -> Void

enum LocationSearchResult {
  case Success([AnyObject!])
  case Error(NSError)
}

struct LocationSearch {
  
  let apiKey = ""
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
      parse: parsePredictions
    )
    
    let client = HTTPClient()
    client.apiRequest(self.urlSession, resource: resource, failure: { (reason: Reason, data: NSData?) -> () in
      
    }) { (predictions: Predictions) in
      print(predictions)
    }
  }
  
}