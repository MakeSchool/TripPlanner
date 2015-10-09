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
  let serverID: String?
}

extension JSONWaypoint: Decodable {
  
  static func create(latitude: Double)(longitude: Double)(name: String)(serverID: String?) -> JSONWaypoint {
    return JSONWaypoint(location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), name: name, serverID: serverID)
  }
  
  static func decode(j: JSON) -> Decoded<JSONWaypoint> {
    return JSONWaypoint.create
      <^> j <| "latitude"
      <*> j <| "longitude"
      <*> j <| "name"
      <*> j <|? "_id"
  }
  
}

extension JSONWaypoint {
  
  init(waypoint: Waypoint) {
    location = waypoint.location!
    name = waypoint.name ?? ""
    serverID = waypoint.name
  }
  
  func JSONRepresentation() -> [String: AnyObject] {
    
    var JSONRep: [String: AnyObject] = [
      "longitude": location.longitude,
      "latitude": location.latitude,
      "name": "\(name)"
    ]
    
    if let serverID = serverID {
      JSONRep["_id"] = serverID
    }
    
    return JSONRep
  }
  
}