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
  let serverID: String?
  let lastUpdate: NSTimeInterval
}

extension JSONTrip: Decodable {
  
  static func create(latitude: Double?)(longitude: Double?)(locationDescription: String)(waypoints: [JSONWaypoint])(serverID: String?)(lastUpdate: NSTimeInterval) -> JSONTrip {
    var location: CLLocationCoordinate2D?
    
    if let longitude = longitude, latitude = latitude {
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    return JSONTrip(location: location, locationDescription: locationDescription, waypoints: waypoints, serverID: serverID, lastUpdate: lastUpdate)
  }
  
  static func decode(j: JSON) -> Decoded<JSONTrip> {
    return JSONTrip.create
      <^> j <|? "longitude"
      <*> j <|? "latitude"
      <*> j <| "description"
      <*> j <|| "waypoints"
      <*> j <|? "_id"
      <*> j <| "lastUpdate"
  }
  
  func JSONRepresentation() -> [String: AnyObject] {
    var JSONRep: [String: AnyObject] = [
      "description": locationDescription,
      "lastUpdate": lastUpdate,
      "waypoints": waypoints.map { $0.JSONRepresentation() }
    ]
    
    if let location = location {
      JSONRep["longitude"] = location.longitude
      JSONRep["latitude"] = location.latitude
    }
    
    if let serverID = serverID {
      JSONRep["_id"] = serverID
    }
    
    return JSONRep
  }
  
}

extension JSONTrip {
  
  init(trip: Trip) {
    // TODO: consider whether or not trip should have location
    location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    locationDescription = trip.locationDescription ?? ""
    serverID = trip.serverID
    lastUpdate = trip.lastUpdate?.doubleValue ?? 0.0
    
    let waypointsArray = trip.waypoints?.allObjects as? [Waypoint]
    if let waypointsArray = waypointsArray {
       waypoints = waypointsArray.map { JSONWaypoint(waypoint: $0) }
    } else {
      waypoints = []
    }
   
  }
  
}