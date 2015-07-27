//
//  LocationSearchResult+JSON.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/27/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import Argo

func parsePredictions(data: NSData) -> Predictions? {
  let json: AnyObject? = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
  if let j: AnyObject = json {
    let predictionsDecoded: Decoded<Predictions> = decode(j)
    
    switch predictionsDecoded {
    case let .Success(value): return value
    case let .TypeMismatch(error):
      assertionFailure(error)
      return nil
    case let .MissingKey(error):
      assertionFailure(error)
      return nil
    }
  } else {
    return nil
  }
}

extension Predictions: Decodable {
  static func create(predictions: [LocationSearchEntry]) -> Predictions {
    return Predictions(predictions: predictions)
  }
  
  static func decode(j: JSON) -> Decoded<Predictions> {
    return Predictions.create
      <^> j <|| "predictions"
  }
}

extension LocationSearchEntry: Decodable {
  static func create(description: String)(id: String)(matchedSubstrings: [SubstringMatch])(placedId:String)(reference: String)(terms: [Term])(types: [String]) -> LocationSearchEntry {
    return LocationSearchEntry(description: description, id: id, matchedSubstrings: matchedSubstrings, placeId: placedId, reference: reference, terms: terms, types: types)
  }
  
  static func decode(j: JSON) -> Decoded<LocationSearchEntry> {
    return LocationSearchEntry.create
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