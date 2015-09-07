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
  
  // TODO: consider renaming 'Place.description' to make this type CustomStringConvertible
  var placeDescription: String {
    get {
       return terms.map{$0.value}.joinWithSeparator(", ")
    }
  }
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

// MARK: Equatable implementations

extension Place: Equatable {}

func ==(lhs: Place, rhs: Place) -> Bool {
	 return
    lhs.description == rhs.description &&
      lhs.id == rhs.id &&
      lhs.matchedSubstrings == rhs.matchedSubstrings &&
      lhs.placeId == rhs.placeId &&
      lhs.reference == rhs.reference &&
      lhs.terms == rhs.terms &&
      lhs.types == rhs.types
}

extension SubstringMatch: Equatable {}

func ==(lhs: SubstringMatch, rhs: SubstringMatch) -> Bool {
  return
    lhs.length == rhs.length &&
    lhs.offset == rhs.offset
}

extension Term: Equatable {}

func ==(lhs: Term, rhs: Term) -> Bool {
  return
    lhs.offset == rhs.offset &&
    lhs.value == rhs.value
}
