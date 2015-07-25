//
//  AddTripViewController.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/22/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit
import GoogleMaps
import HNKGooglePlacesAutocomplete
import DVR

class AddTripViewController: UIViewController {
  
  var session: Session!
  
  override func viewWillAppear(animated: Bool) {
    
//    let filter = GMSAutocompleteFilter()
//    filter.type = GMSPlacesAutocompleteTypeFilter.City
//    let placesClient = GMSPlacesClient()
//    placesClient.autocompleteQuery("Stuttgart", bounds: nil, filter: filter, callback: { (results, error: NSError?) -> Void in
//      if let error = error {
//        print("Autocomplete error \(error)")
//      }
//      
//      for result in results! {
//        if let result = result as? GMSAutocompletePrediction {
//          print("Result \(result.attributedFullText) with placeID \(result.placeID)")
//        }
//      }
//    })
    
    session = Session(cassetteName: "example", testBundle: NSBundle.mainBundle())
    
    LocationSearch(urlSession: session).findPlaces("Stuttgart") { result in

    }
  }
  
}