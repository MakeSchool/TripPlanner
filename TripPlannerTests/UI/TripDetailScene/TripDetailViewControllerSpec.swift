//
//  TripDetailViewControllerSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/30/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

import Quick
import Nimble
import UIKit

@testable import TripPlanner

class TripDetailViewControllerSpec: QuickSpec {
  
  override func spec() {
    
    describe("TripDetailViewController") {
      var tripDetailViewController: TripDetailViewController!
      
      beforeEach {
        tripDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TripDetailViewController") as! TripDetailViewController
        // force view to be loaded, so we can check for outlets
        let _ = tripDetailViewController.view
      }
      
      
    }
  }
  
}