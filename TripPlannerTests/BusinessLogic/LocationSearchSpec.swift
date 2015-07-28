//
//  LocationSearchSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/27/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Quick
import Nimble
import CoreLocation
import DVR

@testable import TripPlanner

class LocationSearchSpec: QuickSpec {
  
  override func spec() {

    describe("LocationSearch") {
      var locationSearchClient: LocationSearch!
      
      context("successful API requests") {
        beforeEach {
          let session = Session(cassetteName: "google_maps_api", testBundle: NSBundle.mainBundle())
          locationSearchClient = LocationSearch(urlSession: session, apiKey: "")
        }
        
        describe("findPlaces") {
          it("calls the callback with parsed data when the request is successful") {
            waitUntil {done in
              locationSearchClient.findPlaces("S") { result in
                if case let .Success(predictions) = result {
                  if (predictions.predictions[0].id == "1b9ea3c094d3ac23c9a3afa8cd4d8a41f05de50a") {
                    done()
                  }
                }
              }
            }
          }
        }
        
        describe("detailsForPlace") {
          it("calls the callback with parsed data when the request is successful") {
            waitUntil { done in
              let place = Place(description: "", id: "", matchedSubstrings: [], placeId: "EjBTdGVpbmVyIFN0cmVldCwgU2FuIEZyYW5jaXNjbywgQ0EsIFVuaXRlZCBTdGF0ZXM", reference: "", terms: [], types: [])
              locationSearchClient.detailsForPlace(place) { result in
                let expectedLatitude = 37.784956600000001
                let expectedLongitude = -122.4347061
                
                if case let .Success(placeDetails) = result
                  where placeDetails.location.latitude == expectedLatitude && placeDetails.location.longitude == expectedLongitude {
                    done()
                }
              }
            }
          }
        }
      }
      
      context("successful API requests") {
        beforeEach {
          let session = Session(cassetteName: "google_maps_api_404", testBundle: NSBundle.mainBundle())
          locationSearchClient = LocationSearch(urlSession: session, apiKey: "")
        }
        
        describe("findPlaces") {
          it("it calls the failure callback") {
            waitUntil {done in
              locationSearchClient.findPlaces("S") { result in
                if case let .Failure(reason) = result {
                  if case let .NoSuccessStatusCode(statusCode) = reason where statusCode == 404 {
                    done()
                  }
                }
              }
            }
          }
        }
        
        describe("detailsForPlace") {
          it("calls the failure callback") {
            waitUntil {done in
              let place = Place(description: "", id: "", matchedSubstrings: [], placeId: "EjBTdGVpbmVyIFN0cmVldCwgU2FuIEZyYW5jaXNjbywgQ0EsIFVuaXRlZCBTdGF0ZXM", reference: "", terms: [], types: [])
              locationSearchClient.detailsForPlace(place) { result in
                if case let .Failure(reason) = result {
                  if case let .NoSuccessStatusCode(statusCode) = reason where statusCode == 404 {
                    done()
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
