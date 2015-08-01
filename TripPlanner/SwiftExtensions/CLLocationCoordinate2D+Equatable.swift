//
//  CLLocationCoordinate2D+Comparable.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/31/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
  return
    lhs.latitude == rhs.latitude &&
      lhs.longitude == rhs.longitude
}