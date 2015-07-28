//
//  PlaceDetails.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/27/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

struct PlaceDetails {
  let result: PlaceDetailsResult
}

struct PlaceDetailsResult {
  let geometry: PlaceDetailsResultGeometry
}

struct PlaceDetailsResultGeometry {
  let location: PlaceDetailsResultLocation
}

struct PlaceDetailsResultLocation {
  let latitude: Double
  let longitude: Double
}