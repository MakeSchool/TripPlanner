//
//  LocationSearchResult.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/24/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreLocation

struct Place {
  let description: String
  let id: String
  let matchedSubstrings: [SubstringMatch]
  let placeId: String
  let reference: String
  let terms: [Term]
  let types: [String]
}

struct PlaceWithLocation {
  let locationSearchEntry: Place
  let location: CLLocationCoordinate2D
}

struct Predictions {
  let predictions: [Place]
}

struct Term {
  let offset: Int
  let value: String
}

struct SubstringMatch {
  let length: Int
  let offset: Int
}