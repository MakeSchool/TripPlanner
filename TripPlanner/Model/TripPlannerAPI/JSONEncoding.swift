//
//  JSONEncoding.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 10/8/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

struct JSONEncoding {
  
  static func encodeJSONTrip(trip: Trip) -> NSData {
    let JSONBody = JSONTrip(trip: trip).JSONRepresentation()
    let JSONData = try! NSJSONSerialization.dataWithJSONObject(JSONBody, options: NSJSONWritingOptions(rawValue: 0))
    
    return JSONData
  }
  
}