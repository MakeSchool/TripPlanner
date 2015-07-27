//
//  PlaceDetails.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/27/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import Argo
import Runes

struct PlaceDetails: Decodable {
  let result: PlaceDetailsResult
  
  static func create(result: PlaceDetailsResult) -> PlaceDetails {
    return PlaceDetails(result: result)
  }
  
  static func decode(j: JSON) -> Decoded<PlaceDetails> {
    return PlaceDetails.create
      <^> j <| "result"
  }
}

struct PlaceDetailsResult: Decodable {
  let geometry: PlaceDetailsResultGeometry
  
  static func create(geometry: PlaceDetailsResultGeometry) -> PlaceDetailsResult {
    return PlaceDetailsResult(geometry: geometry)
  }
  
  static func decode(j: JSON) -> Decoded<PlaceDetailsResult> {
    return PlaceDetailsResult.create
      <^> j <| "geometry"
  }
}

struct PlaceDetailsResultGeometry: Decodable {
  let location: PlaceDetailsResultLocation
  
  static func create(location: PlaceDetailsResultLocation) -> PlaceDetailsResultGeometry {
    return PlaceDetailsResultGeometry(location: location)
  }

  static func decode(j: JSON) -> Decoded<PlaceDetailsResultGeometry> {
    return PlaceDetailsResultGeometry.create
      <^> j <| "location"
  }
}

struct PlaceDetailsResultLocation: Decodable {
  let latitude: Double
  let longitude: Double

  static func create(latitude: Double)(longitude: Double) -> PlaceDetailsResultLocation {
    return PlaceDetailsResultLocation(latitude: latitude, longitude: longitude)
  }
  
  static func decode(j: JSON) -> Decoded<PlaceDetailsResultLocation> {
    return PlaceDetailsResultLocation.create
      <^> j <| "lat"
      <*> j <| "lng"
  }
}