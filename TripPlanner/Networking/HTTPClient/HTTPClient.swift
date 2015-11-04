//
//  HTTPClient.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/27/15.
//  Copyright © 2015 Make School. All rights reserved.
//

// Copyright © 2015 Chris Eidhof
// See the accompanying blog post: http://chris.eidhof.nl/posts/tiny-networking-in-swift.html

import Foundation


enum Method: String { // Bluntly stolen from Alamofire
  case OPTIONS = "OPTIONS"
  case GET = "GET"
  case HEAD = "HEAD"
  case POST = "POST"
  case PUT = "PUT"
  case PATCH = "PATCH"
  case DELETE = "DELETE"
  case TRACE = "TRACE"
  case CONNECT = "CONNECT"
}

struct Resource<A> {
  let baseURL: String
  let path: String
  let queryString: String?
  let method : Method
  let requestBody: NSData?
  let headers : [String:String]?
  let parse: NSData -> A?
}

enum Reason {
  case CouldNotParseJSON
  case NoData
  case NoSuccessStatusCode(statusCode: Int)
  case Other(NSError)
}

struct HTTPClient {
  
  func apiRequest<A>(session: NSURLSession = NSURLSession.sharedSession(), resource: Resource<A>, failure: (Reason, NSData?) -> (), completion: A -> ()) {
    let baseURL = NSURL(string: resource.baseURL)
    var url = baseURL?.URLByAppendingPathComponent(resource.path)
    
    if let queryString = resource.queryString {
      url = NSURL(string: "?\(queryString)", relativeToURL: url)
    }
    let request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = resource.method.rawValue
    request.HTTPBody = resource.requestBody
    
    if let headers = resource.headers {
      for (key,value) in headers {
        request.setValue(value, forHTTPHeaderField: key)
      }
    }
    
    let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
      if let httpResponse = response as? NSHTTPURLResponse {
        if (isSuccessStatusCode(httpResponse.statusCode)) {
          if let responseData = data {
            if let result = resource.parse(responseData) {
              completion(result)
            } else {
              failure(Reason.CouldNotParseJSON, data)
            }
          } else {
            failure(Reason.NoData, data)
          }
        } else {
          failure(Reason.NoSuccessStatusCode(statusCode: httpResponse.statusCode), data)
        }
      } else {
        failure(Reason.Other(error!), data)
      }
    }
    task.resume()
  }
  
  static func escape(string: String) -> String {
    let generalDelimiters = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimiters = "!$&'()*+,;="
    
    let allowedCharacters = generalDelimiters + subDelimiters
    let customAllowedSet =  NSCharacterSet(charactersInString:allowedCharacters).invertedSet
    let escapedString = string.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
    
    return escapedString!
  }
  
}

func isSuccessStatusCode(statusCode: Int) -> Bool {
  return (statusCode / 200 == 1)
}