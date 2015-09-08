//
//  JSONTrip.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 9/7/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreLocation

struct JSONTrip {
  let location: CLLocationCoordinate2D
  let locationDescription: String
  let waypoints: [JSONWaypoint]
}