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
import Result
import CoreLocation

@testable import TripPlanner

class addWaypointViewControllerSpec: QuickSpec {
  
  override func spec() {
    
    describe("addWaypointViewController") {
      var addWaypointViewController: AddWaypointViewController!
      
      beforeEach {
        addWaypointViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AddWaypointViewController") as! AddWaypointViewController
        // force view to be loaded, so we can check for outlets
        let _ = addWaypointViewController.view
      }
      
      describe("after loading") {
        it("has outlets set up correctly") {
          expect(addWaypointViewController.tableView).notTo(beNil())
          expect(addWaypointViewController.mapView).notTo(beNil())
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
          addWaypointViewController.locationSearch = locationSearchMock
          addWaypointViewController.searchBar(UISearchBar(), textDidChange: "Stuttgart")
          
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
          addWaypointViewController.locationSearch = locationSearchMock
          addWaypointViewController.searchBar(UISearchBar(), textDidChange: "")
          
          expect(locationSearchMock.called).to(beFalse())
          expect(addWaypointViewController.locations).to(beEmpty())
        }
      }
      
      describe("handleSearchResult") {
        it("stores the location results upon successful request") {
          let place = Place(description: "", id: "", matchedSubstrings: [], placeId: "1", reference: "", terms: [], types: [])
          let predictions = Predictions(predictions: [place])
          let result: Result<Predictions, Reason> = .Success(predictions)
          
          addWaypointViewController.handleSearchResult(result)
          
          expect(addWaypointViewController.locations[0].placeId).to(equal("1"))
        }
        
        it("invokes the error handler upon a failed request") {
          let result: Result<Predictions, Reason> = .Failure(.NoSuccessStatusCode(statusCode: 404))
          
          class MockErrorHandler: DefaultErrorHandler {
            var called = false;
            
            override func displayErrorMessage(message: String) {
              called = true
            }
          }
          
          let mockErrorHandler = MockErrorHandler()
          
          addWaypointViewController.errorHandler = mockErrorHandler
          addWaypointViewController.handleSearchResult(result)
          
          expect(mockErrorHandler.called).to(beTrue())
        }
      }
      
      describe("handleLocationDetailResult") {
        it("highlights the location on the map upon a successful request") {
          class LocationSearchMapViewDecoratorMock: LocationSearchMapViewDecorator {
            var setPlace: Place?
            
            override var displayedLocation: PlaceWithLocation? {
              didSet {
                setPlace = displayedLocation?.locationSearchEntry
              }
            }
          }
          
          let locationSearchMapViewDecoratorMock = LocationSearchMapViewDecoratorMock(mapView: addWaypointViewController.mapView)
          addWaypointViewController.mapViewDecorator = locationSearchMapViewDecoratorMock
          
          let place = Place(description: "", id: "", matchedSubstrings: [], placeId: "1", reference: "", terms: [], types: [])
          let placeWithLocation = PlaceWithLocation(locationSearchEntry: place, location: CLLocationCoordinate2D(latitude: 10, longitude: 10))
          let result: Result<PlaceWithLocation, Reason> = .Success(placeWithLocation)
          
          addWaypointViewController.handleLocationDetailResult(result)
          
          expect(locationSearchMapViewDecoratorMock.setPlace).to(equal(place))
        }
        
        it("displays an error message and deselects the table view row upon a failed request") {
          let result: Result<PlaceWithLocation, Reason> = .Failure(.NoSuccessStatusCode(statusCode: 404))
          
          class MockErrorHandler: DefaultErrorHandler {
            var called = false;
            
            override func displayErrorMessage(message: String) {
              called = true
            }
          }
          
          let mockErrorHandler = MockErrorHandler()
          
          addWaypointViewController.errorHandler = mockErrorHandler
          addWaypointViewController.handleLocationDetailResult(result)
          
          expect(mockErrorHandler.called).to(beTrue())
        }
      }
      
      describe("tableViewDidSelectRowAtIndexPath") {
        it("requests location details for the selected location") {
          let place = Place(description: "", id: "", matchedSubstrings: [], placeId: "1", reference: "", terms: [], types: [])
          let predictions = Predictions(predictions: [place])
          addWaypointViewController.locations = predictions.predictions
          
          class MockLocationSearch: LocationSearch {
            var calledWithPlace :Place?
            
            override func detailsForPlace(place: Place, callback: PlacesDetailsCallback) {
              calledWithPlace = place;
            }
          }
          
          let mockLocationSearch = MockLocationSearch()
          addWaypointViewController.locationSearch = mockLocationSearch
          
          let tableView = addWaypointViewController.tableView
          addWaypointViewController.tableView(tableView, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
          
          expect(mockLocationSearch.calledWithPlace?.placeId).to(equal("1"))
        }
      }
      
      describe("tableView rows and sections") {
        it("show results from location search") {
          let place = Place(description: "", id: "", matchedSubstrings: [], placeId: "1", reference: "", terms: [], types: [])
          let predictions = Predictions(predictions: [place])
          addWaypointViewController.locations = predictions.predictions
          
          let rows = addWaypointViewController.tableView(addWaypointViewController.tableView, numberOfRowsInSection: 0)
          let cell = addWaypointViewController.tableView(addWaypointViewController.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! LocationResultTableViewCell
          
          expect(rows).to(equal(1))
          expect(cell.model).to(equal(place))
        }
      }

    }
  }
}
