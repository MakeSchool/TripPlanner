//
//  JSONParsing.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/27/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import Argo

func parse<T: Decodable where T == T.DecodedType>(data: NSData) -> T? {
  let json: AnyObject? = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
  if let j: AnyObject = json {
    let resultDecoded: Decoded<T> = decode(j)
    
    switch resultDecoded {
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

// TODO: avoid duplication

func parse<T: Decodable where T == T.DecodedType>(data: NSData) -> [T]? {
  let json: AnyObject? = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
  if let j: AnyObject = json {
    let resultDecoded: Decoded<[T]> = decode(j)
    
    switch resultDecoded {
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