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
      
      describe("after loading") {
        it("has outlets set up correctly") {
          expect(addTripViewController.tableView).notTo(beNil())
          expect(addTripViewController.mapView).notTo(beNil())
        }
      }
      
      describe("search bar") {
        it("accesses the LocationSearch when a search term is entered") {
          class LocationSearchMock: LocationSearch {
            var searchedTerm: String?
            
            override func findPlaces(searchString: String, callback: LocationSearchCallback) {
                searchedTerm = searchString
            }
          }
          
          let locationSearchMock = LocationSearchMock()
          addTripViewController.locationSearch = locationSearchMock
          addTripViewController.searchBar(UISearchBar(), textDidChange: "Stuttgart")
          
          expect(locationSearchMock.searchedTerm!).to(equal("Stuttgart"))
        }
        
        it("resets the search results without calling API when textfield is blank") {
          class LocationSearchMock: LocationSearch {
            var called = false
            
            override func findPlaces(searchString: String, callback: LocationSearchCallback) {
              called = true
            }
          }
          
          let locationSearchMock = LocationSearchMock()
          addTripViewController.locationSearch = locationSearchMock
          addTripViewController.searchBar(UISearchBar(), textDidChange: "")
          
          expect(locationSearchMock.called).to(beFalse())
          expect(addTripViewController.locations).to(beEmpty())
        }
      }

    }
  }
}
