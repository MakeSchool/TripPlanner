//
//  LocationSearchSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/27/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Quick
import Nimble
import DVR

@testable import TripPlanner

class LocationSearchSpec: QuickSpec {
  
  override func spec() {

    describe("LocationSearch") {
      var locationSearchClient: LocationSearch!
      
      beforeEach {
        let session = Session(cassetteName: "google_maps_api", testBundle: NSBundle.mainBundle())
        locationSearchClient = LocationSearch(urlSession: session, apiKey: "")
      }
      
      it("calls the callback with parsed data when the request is successful") {
        waitUntil(timeout: 1) {done in
          locationSearchClient.findPlaces("S") { result in
            switch result {
            case let .Success(predictions):
              if (predictions.predictions[0].id == "1b9ea3c094d3ac23c9a3afa8cd4d8a41f05de50a") {
                done()
              }
              // TODO: look into way to fail asynchronous test
            case .Failure(_): break
            }
          }
        }
      }
      
    }
  
  }
}
