//
//  WaypointDetailViewControllerSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 8/7/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

import Quick
import Nimble
import UIKit

@testable import TripPlanner

class WaypointDetailViewControllerSpec: QuickSpec {
  
  override func spec() {
    
    describe("WaypointDetailViewController") {
      var waypointDetailViewController: WaypointDetailViewController!
      
      beforeEach {
        waypointDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WaypointDetailViewController") as! WaypointDetailViewController
        // force view to be loaded, so we can check for outlets
        let _ = waypointDetailViewController.view
      }
      
      
      describe("viewWillAppear") {
        
        beforeEach {
          waypointDetailViewController.viewWillAppear(false)
        }
        
        it("updates the naviation item to reflect the selected location") {
          expect(waypointDetailViewController.navigationItem.title).to(equal(""))
        }
        
      }
      
    }
  }
}

