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
import ListKit

class LocationResulTableViewCell: UITableViewCell, TableViewCellProtocol {
  var model:LocationSearchEntry? {
    didSet {
      if let model = model {
        self.textLabel!.text = " ,".join(model.terms.map{$0.value})
      }
    }
  }
}

class AddTripViewController: UIViewController {
  
  var session: Session!
  var locations: [LocationSearchEntry] = [] {
    didSet {
      arrayDataSource.array = locations
      tableView.reloadData()
    }
  }
  
  var arrayDataSource: ArrayDataSource<LocationResulTableViewCell, LocationSearchEntry>!
  
  @IBOutlet var tableView: UITableView!
  
  override func viewDidLoad() {
    arrayDataSource = ArrayDataSource(array: locations, cellType:LocationResulTableViewCell.self)
    tableView.dataSource = arrayDataSource
  }
  
  override func viewWillAppear(animated: Bool) {
    session = Session(cassetteName: "google_maps_api", testBundle: NSBundle.mainBundle())
    LocationSearch(urlSession: session).findPlaces("St") { result in
      switch result {
      case let .Success(predictions):
        self.locations = predictions.predictions
      case let .Error(error):
        print(error)
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