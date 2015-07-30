//
//  UIConstants.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/30/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

struct Storyboard {
  struct UnwindSegues {
    static let ExitSegue = "ExitSegue"
  }
  
  struct Main {
    static var name = "Main"
    
    struct MainViewController {
      static var name = "MainViewController"
      
      struct Segues {
          static let AddNewTripSegue = "AddNewTrip"
      }
    }
    
    struct TripDetailViewController {
      static var name = "TripDetailViewController"

    }
  }
}