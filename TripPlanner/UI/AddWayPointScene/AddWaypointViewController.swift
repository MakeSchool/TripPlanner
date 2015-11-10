//
//  AddTripViewController.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/22/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit
import ListKit
import MapKit
import Result

//TODO: Show google logo as part of search
class LocationResultTableViewCell: UITableViewCell, ListKitCellProtocol {
  var model: Place? {
    didSet {
      if let model = model {
        self.textLabel!.text = model.placeDescription
      }
    }
  }
}

class AddWaypointViewController: UIViewController {
  
  // MARK: IBOutlets
  @IBOutlet var tableView: UITableView!
  @IBOutlet var mapView: MKMapView!
  
  // MARK: Properties and Property Observers
  var errorHandler = DefaultErrorHandler()
  var session: NSURLSession = NSURLSession.sharedSession()
  var arrayDataSource: ArrayDataSource<LocationResultTableViewCell, Place>!
  var mapViewDecorator: LocationSearchMapViewDecorator!
  var locationSearch: LocationSearch
  var waypoint: Waypoint?
  
  var displayedLocation: PlaceWithLocation? {
    didSet {
      mapViewDecorator.displayedLocation = displayedLocation
      waypoint?.name = displayedLocation?.locationSearchEntry.placeDescription
      waypoint?.location = displayedLocation?.location
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    locationSearch = LocationSearch(urlSession: session)
    
    super.init(coder: aDecoder)
  }
  
  var locations: [Place] = [] {
    didSet {
      arrayDataSource.array = locations
      tableView.reloadData()
    }
  }

  var searchTerm: String? {
    didSet {
      if let searchTerm = searchTerm where !searchTerm.isEmpty {
        let urlSafeSerchTerm = URLEncodedString(searchTerm)
        locationSearch.findPlaces(urlSafeSerchTerm, callback: handleSearchResult)
      } else {
        locations = []
      }
    }
  }
  
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    arrayDataSource = ArrayDataSource(array: locations, cellType:LocationResultTableViewCell.self)
    tableView.dataSource = arrayDataSource
    tableView.delegate = self
    
    mapViewDecorator = LocationSearchMapViewDecorator(mapView: mapView)
  }
  
  // MARK: API Callbacks
  
  func handleSearchResult(result: Result<Predictions, Reason>) -> Void {
    switch result {
    case let .Success(predictions):
      self.locations = predictions.predictions
    case .Failure(_):
      self.errorHandler.displayErrorMessage(
        NSLocalizedString("add_trip.cannot_complete_search", comment: "Error message: the search returned an error, sorry! Please try again later")
      )
    }
  }
  
  func handleLocationDetailResult(result: Result<PlaceWithLocation, Reason>) -> Void {
    switch result {
    case let .Success(place):
      displayedLocation = place
    case .Failure(_):
      self.errorHandler.displayErrorMessage(
        NSLocalizedString("add_trip.cannot_retrieve_place_details", comment: "Error message: cannot retrieve information for this place, please choose another one.")
      )
      
      if let indexPath = tableView.indexPathForSelectedRow {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
      }
    }
  }
  
}

// MARK: TableViewDataSource

extension AddWaypointViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrayDataSource.tableView(tableView, numberOfRowsInSection: section)
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return arrayDataSource.tableView(tableView, cellForRowAtIndexPath: indexPath)
  }
  
}

// MARK: TableViewDelegate

extension AddWaypointViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    locationSearch.detailsForPlace(arrayDataSource.array[indexPath.row], callback: handleLocationDetailResult)
  }
  
}

// MARK: SearchBarDelegate

extension AddWaypointViewController: UISearchBarDelegate {
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    searchTerm = searchText
  }
  
}