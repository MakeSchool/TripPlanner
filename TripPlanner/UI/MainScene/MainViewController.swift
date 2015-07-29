//
//  MainViewController.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/21/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import ListKit
import CoreData

class MainViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!

  var coreDataClient: CoreDataClient!
  var currentTrip: Trip?
  var temporaryContext: NSManagedObjectContext?
  
  private var arrayDataSource :ArrayDataSource<TripMainTableViewCell, Trip>?
  
  var trips: [Trip]? {
    didSet {
      if let trips = trips {
        let nib = UINib(nibName: "TripMainTableViewCell", bundle: NSBundle.mainBundle())
        arrayDataSource = ArrayDataSource(array: trips, cellType: TripMainTableViewCell.self, nib: nib)
      }
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    trips = coreDataClient.allTrips()
    
    self.tableView.dataSource = arrayDataSource
  }
  
  // MARK: Segues
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "AddNewTrip") {
      let (newTrip, newContext) = coreDataClient.createObjectInTemporaryContext(Trip.self)
      newTrip.locationDescription = "Trip to San Francisco"
      currentTrip = newTrip
      temporaryContext = newContext
    } else if (segue.identifier == "ShowTripDetails") {
      let row = tableView.indexPathsForSelectedRows?[0].row
  
      if let row = row, trips = trips {
        let trip = trips[row]
        let tripDetailViewController = segue.destinationViewController as? TripDetailViewController
        tripDetailViewController?.trip = trip
      }
    }
  }
  
  @IBAction func saveTrip(segue:UIStoryboardSegue) {
    try! temporaryContext?.save()
    coreDataClient.saveStack()
  }
  
  @IBAction func cancelTripCreation(segue:UIStoryboardSegue) {
    temporaryContext = nil
  }
  
}

extension MainViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("ShowTripDetails", sender: self)
  }
  
}