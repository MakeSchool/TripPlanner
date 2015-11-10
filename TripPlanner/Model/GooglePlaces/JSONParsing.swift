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
  do {
    let json: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
    if let j: AnyObject = json {
      let resultDecoded: Decoded<T> = decode(j)
      return evaluateDecodedResult(resultDecoded)
    } else {
      return nil
    }
  } catch let error as NSError {
    print(error)
    
    return nil
  }
}

//// TODO: avoid duplication once constrained extensions can conform to a protocol

func parse<T: Decodable where T == T.DecodedType>(data: NSData) -> [T]? {
  let json: AnyObject? = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
  if let j: AnyObject = json {
    let resultDecoded: Decoded<[T]> = decode(j)
    return evaluateDecodedResult(resultDecoded)
  } else {
    return nil
  }
}

func evaluateDecodedResult<T>(decoded: Decoded<T>) -> T? {
  
  switch decoded {
  case let .Success(value): return value
  default:
    assertionFailure()
    return nil
  }
}