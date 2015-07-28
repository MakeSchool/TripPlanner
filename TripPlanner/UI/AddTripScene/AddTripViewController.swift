//
//  AddTripViewController.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/22/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit
import GoogleMaps
import DVR
import ListKit
import MapKit

//TODO: Show google logo as part of search
class LocationResultTableViewCell: UITableViewCell, TableViewCellProtocol {
  var model: Place? {
    didSet {
      if let model = model {
        self.textLabel!.text = ", ".join(model.terms.map{$0.value})
      }
    }
  }
}

class AddTripViewController: UIViewController {
  
  var errorHandler = DefaultErrorHandler()
  var session: Session!
  var locations: [Place] = [] {
    didSet {
      arrayDataSource.array = locations
      tableView.reloadData()
    }
  }
  
  var arrayDataSource: ArrayDataSource<LocationResultTableViewCell, Place>!
  var mapViewDecorator: LocationSearchMapViewDecorator!
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var mapView: MKMapView!
  
  override func viewDidLoad() {
    arrayDataSource = ArrayDataSource(array: locations, cellType:LocationResultTableViewCell.self)
    tableView.dataSource = arrayDataSource
    tableView.delegate = self
    
    mapViewDecorator = LocationSearchMapViewDecorator(mapView: mapView)
  }
  
  override func viewWillAppear(animated: Bool) {
    session = Session(cassetteName: "google_maps_api", testBundle: NSBundle.mainBundle())
    LocationSearch(urlSession: session).findPlaces("St") { result in
      switch result {
      case let .Success(predictions):
        self.locations = predictions.predictions
      case let .Failure(error): break
//        self.errorHandler.handleError(error, displayToUser: false)
      }
    }
  }
  
}

extension AddTripViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrayDataSource.tableView(tableView, numberOfRowsInSection: section)
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return arrayDataSource.tableView(tableView, cellForRowAtIndexPath: indexPath)
  }
  
}

extension AddTripViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    session = Session(cassetteName: "google_maps_api", testBundle: NSBundle.mainBundle())
    LocationSearch(urlSession: session).detailsForPlace(arrayDataSource.array[indexPath.row]) { result in
      switch result {
      case let .Success(place):
        self.mapViewDecorator.displayedLocation = place
      case .Failure(_):
        self.errorHandler.displayErrorMessage(
          NSLocalizedString("add_trip.cannot_retrieve_place_details", comment: "Error message: cannot retrieve information for this place, please choose another one.")
        )
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
      }
    }
  }
  
}