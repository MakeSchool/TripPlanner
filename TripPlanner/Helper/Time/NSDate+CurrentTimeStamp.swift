//
//  TimeHelper.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 10/29/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

extension NSDate {
  static func currentTimestamp() -> NSTimeInterval {
    return NSDate.timeIntervalSinceReferenceDate()
  }
}