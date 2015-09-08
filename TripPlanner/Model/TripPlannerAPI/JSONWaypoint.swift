//
//  JSONWaypoint.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 9/7/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreLocation
import Argo

struct JSONWaypoint {
  let location: CLLocationCoordinate2D
  let name: String
}

extension JSONWaypoint: Decodable {
  
  static func create(latitude: Double)(longitude: Double)(name: String) -> JSONWaypoint {
    return JSONWaypoint(location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), name: name)
  }
  
  static func decode(j: JSON) -> Decoded<JSONWaypoint> {
    return JSONWaypoint.create
      <^> j <| "longitude"
      <*> j <| "latitude"
      <*> j <| "name"
  }
  
}