//
//  AddTripSceneSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/28/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Quick
import Nimble
import UIKit

@testable import TripPlanner

class AddTripViewControllerSpec: QuickSpec {
  
  override func spec() {
    
    describe("AddTripViewController") {
      var addTripViewController: AddTripViewController!
      
      beforeEach {
        addTripViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AddTripViewController") as! AddTripViewController
        // force view to be loaded, so we can check for outlets
        let _ = addTripViewController.view
      }
      
      
    }
  }
  
}
