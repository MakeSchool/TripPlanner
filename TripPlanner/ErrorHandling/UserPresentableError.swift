//
//  UserPresentableError.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/27/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

protocol UserPresentableError {
  var error: ErrorType { get }
  var description: String { get }
}