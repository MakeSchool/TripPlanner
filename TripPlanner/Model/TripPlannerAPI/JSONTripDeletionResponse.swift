//
//  JSONTripDeletionResponse.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 10/9/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import Argo

struct JSONTripDeletionResponse {
  let deletedTripIdentifier: TripServerID
}

extension JSONTripDeletionResponse: Decodable {
 
  static func create(deletedTripIdentifier: TripServerID) -> JSONTripDeletionResponse {
    return JSONTripDeletionResponse(deletedTripIdentifier: deletedTripIdentifier)
  }
  
  static func decode(j: JSON) -> Decoded<JSONTripDeletionResponse> {
    return JSONTripDeletionResponse.create
      <^> j <| "tripIdentifier"
  }
  
}