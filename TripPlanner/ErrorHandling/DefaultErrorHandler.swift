//
//  DefaultErrorHandler.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/27/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

class DefaultErrorHandler {
  
  func handleError(error: ErrorType, displayToUser: Bool) {
    print(error)
  }
  
  func displayErrorMessage(message: String) {
    
  }
    
  func wrap<ReturnType>(@noescape f: () throws -> ReturnType) -> ReturnType? {
    do {
      return try f()
    } catch let error {
      print(error)
      return nil
    }
  }
  
  func wrap<ReturnType>(@noescape f: () throws -> ReturnType?) -> ReturnType? {
    do {
      return try f()
    } catch let error {
      print(error)
      return nil
    }
  }
  
}