//
//  LocationSearchResult.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/24/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import Argo
import Runes

struct LocationSearchEntry {
  let description: String
  let id: String
  let matchedSubstrings: [SubstringMatch]
  let placeId: String
  let reference: String
  let terms: [Term]
  let types: [String]
}

extension LocationSearchEntry: Decodable {
  static func create(description: String)(id: String)(matchedSubstrings: [SubstringMatch])(placedId:String)(reference: String)(terms: [Term])(types: [String]) -> LocationSearchEntry {
    return LocationSearchEntry(description: description, id: id, matchedSubstrings: matchedSubstrings, placeId: placedId, reference: reference, terms: terms, types: types)
  }
  
  static func decode(j: JSON) -> Decoded<LocationSearchEntry> {
    return LocationSearchEntry.create
      <^> j <|  "description"
      <*> j <|  "id"
      <*> j <|| "matchedSubstrings"
      <*> j <|  "placeId"
      <*> j <|  "reference"
      <*> j <|| "terms"
      <*> j <|| "types"
  }
}

struct Term {
  let offset: String
  let value: String
}

extension Term: Decodable {
  static func create(offset: String)(value: String) -> Term {
    return Term(offset: offset, value: value)
  }
  
  static func decode(j: JSON) -> Decoded<Term> {
    return Term.create
      <^> j <| "offset"
      <*> j <| "value"
  }
}

struct SubstringMatch {
  let length: Int
  let offset: Int
}

extension SubstringMatch: Decodable {
  static func create(length: Int)(offset: Int) -> SubstringMatch {
    return SubstringMatch(length: length, offset: offset)
  }
  
  static func decode(j: JSON) -> Decoded<SubstringMatch> {
    return SubstringMatch.create
      <^> j <| "length"
      <*> j <| "offset"
  }
}