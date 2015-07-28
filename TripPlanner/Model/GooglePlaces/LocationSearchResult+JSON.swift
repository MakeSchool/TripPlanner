//
//  LocationSearchResult+JSON.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/27/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import Argo

extension Predictions: Decodable {
  static func create(predictions: [Place]) -> Predictions {
    return Predictions(predictions: predictions)
  }
  
  static func decode(j: JSON) -> Decoded<Predictions> {
    return Predictions.create
      <^> j <|| "predictions"
  }
}

extension Place: Decodable {
  static func create(description: String)(id: String)(matchedSubstrings: [SubstringMatch])(placedId:String)(reference: String)(terms: [Term])(types: [String]) -> Place {
    return Place(description: description, id: id, matchedSubstrings: matchedSubstrings, placeId: placedId, reference: reference, terms: terms, types: types)
  }
  
  static func decode(j: JSON) -> Decoded<Place> {
    return Place.create
      <^> j <|  "description"
      <*> j <|  "id"
      <*> j <|| "matched_substrings"
      <*> j <|  "place_id"
      <*> j <|  "reference"
      <*> j <|| "terms"
      <*> j <|| "types"
  }
}

extension Term: Decodable {
  static func create(offset: Int)(value: String) -> Term {
    return Term(offset: offset, value: value)
  }
  
  static func decode(j: JSON) -> Decoded<Term> {
    return Term.create
      <^> j <| "offset"
      <*> j <| "value"
  }
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