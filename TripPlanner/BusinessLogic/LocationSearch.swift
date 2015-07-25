//
//  LocationSearch.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/23/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import Argo

typealias LocationSearchCallback = LocationSearchResult -> Void

enum LocationSearchResult {
  case Success([AnyObject!])
  case Error(NSError)
}

struct LocationSearch {
  
  let locationSearchEndpointURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="
  let apiKey = ""
  
  let urlSession: NSURLSession
  
  init(urlSession: NSURLSession = NSURLSession.sharedSession()) {
    self.urlSession = urlSession
  }
  
  func findPlaces(searchString: String, callback: LocationSearchCallback) {
    var request = urlRequestForSearchString(searchString)
    
    let task = urlSession.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
      let json: AnyObject? = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
      
      if let j: AnyObject = json {
        let user: Decoded<Predictions> = decode(j)
        print(user)
      }
    }
    
    task.resume()
  }
  
  func urlRequestForSearchString(searchString: String) -> NSURLRequest {
    let searchString = escape(searchString)
    let urlString = "\(locationSearchEndpointURL)\(searchString)&key=\(apiKey)"
    let url = NSURL(string: urlString)!
    
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "GET"
    
    return request
  }
  
  
  func escape(string: String) -> String {
    let generalDelimiters = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimiters = "!$&'()*+,;="
    
    let allowedCharacters = generalDelimiters + subDelimiters
    let customAllowedSet =  NSCharacterSet(charactersInString:allowedCharacters).invertedSet
    let escapedString = string.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
    
    return escapedString!
  }
  
}