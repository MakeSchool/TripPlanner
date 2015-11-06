//
//  String.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 11/6/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

struct URLEncodedString {
  
  private (set) var string: String
  
  init(string: String) {
    self.string = String.URLEscape(string)
  }
  
}