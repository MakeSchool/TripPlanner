//
//  JSONTrip.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 9/7/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreLocation
import Argo

struct JSONTrip {
  let location: CLLocationCoordinate2D?
  let locationDescription: String
  let waypoints: [JSONWaypoint]
}

extension JSONTrip: Decodable {
  
  static func create(latitude: Double?)(longitude: Double?)(locationDescription: String)(waypoints: [JSONWaypoint]) -> JSONTrip {
    var location: CLLocationCoordinate2D?
    
    if let longitude = longitude, latitude = latitude {
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    return JSONTrip(location: location, locationDescription: locationDescription, waypoints: waypoints)
  }
  
  static func decode(j: JSON) -> Decoded<JSONTrip> {
    return JSONTrip.create
      <^> j <|? "longitude"
      <*> j <|? "latitude"
      <*> j <| "description"
      <*> j <|| "waypoints"
  }
  
}