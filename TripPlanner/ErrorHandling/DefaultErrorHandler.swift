//
//  DefaultErrorHandler.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/27/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

struct DefaultErrorHandler {
  
  func handleError(error: ErrorType, displayToUser: Bool) {
    print(error)
  }
  
  func displayErrorMessage(message: String) {
    
  }
  
}