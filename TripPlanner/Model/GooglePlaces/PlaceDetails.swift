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

//MARK: Equatable Implementations

extension PlaceDetails: Equatable {}

func ==(lhs: PlaceDetails, rhs: PlaceDetails) -> Bool {
  return
    lhs.result == rhs.result
}

extension PlaceDetailsResult: Equatable {}

func ==(lhs: PlaceDetailsResult, rhs: PlaceDetailsResult) -> Bool {
  return
    lhs.geometry == rhs.geometry
}

extension PlaceDetailsResultGeometry: Equatable {}

func ==(lhs: PlaceDetailsResultGeometry, rhs: PlaceDetailsResultGeometry) -> Bool {
  return
    lhs.location == rhs.location
}

extension PlaceDetailsResultLocation: Equatable {}

func ==(lhs: PlaceDetailsResultLocation, rhs: PlaceDetailsResultLocation) -> Bool {
  return
    lhs.latitude == rhs.latitude &&
      lhs.longitude == rhs.longitude
}


