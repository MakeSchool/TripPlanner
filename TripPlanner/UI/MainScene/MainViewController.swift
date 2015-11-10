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
  var detailViewTrip: Trip?
  var temporaryContext: NSManagedObjectContext?
  
  private var arrayDataSource :ArrayDataSource<TripMainTableViewCell, Trip>!
  
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
    
    self.tableView.dataSource = self
  }
  
  // MARK: Segues
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "AddNewTrip") {
      let (newTrip, newContext) = coreDataClient.createObjectInTemporaryContext(Trip.self)
      currentTrip = newTrip
      temporaryContext = newContext
      let addTripViewController = segue.destinationViewController as? AddTripViewController
      if let addTripViewController = addTripViewController {
        addTripViewController.currentTrip = currentTrip
      }
    } else if (segue.identifier == "ShowTripDetails") {
      let tripDetailViewController = segue.destinationViewController as? TripDetailViewController
      if let tripDetailViewController = tripDetailViewController {
        prepareTripDetailPresentation(tripDetailViewController)
      }
    }
  }
  
  func prepareTripDetailPresentation(tripDetailVC: TripDetailViewController) {
    tripDetailVC.trip = detailViewTrip
    tripDetailVC.coreDataClient = coreDataClient
  }
  
  // MARK: Unwind Segues
  
  @IBAction func saveTrip(segue:UIStoryboardSegue) {
    if (segue.identifier == Storyboard.UnwindSegues.ExitSaveTripSegue) {
      try! temporaryContext?.save()
      coreDataClient.saveStack()
    }
  }
  
  @IBAction func cancelTripCreation(segue:UIStoryboardSegue) {
    if (segue.identifier == Storyboard.UnwindSegues.ExitCancelTripSegue) {
      temporaryContext = nil
    }
  }
  
  // MARK: Button Callbacks
  @IBAction func refreshButtonTapped(sender: AnyObject) {
    let tripPlannerBackendSynchronizer = TripPlannerBackendSynchronizer(coreDataClient: coreDataClient)
    
    tripPlannerBackendSynchronizer.sync {
      self.trips = self.coreDataClient.allTrips()
      self.tableView.reloadData()
    }
  }
  
}

extension MainViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    guard let trips = trips else { return }
    
    detailViewTrip = trips[indexPath.row]
    performSegueWithIdentifier("ShowTripDetails", sender: self)
  }
  
}

extension MainViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if (editingStyle == .Delete) {
      let tripToDelete = arrayDataSource.array[indexPath.row]
      arrayDataSource.array.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      coreDataClient.markTripAsDeleted(tripToDelete)
      tableView.reloadData()
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return arrayDataSource.tableView(tableView, cellForRowAtIndexPath: indexPath)
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrayDataSource.tableView(tableView, numberOfRowsInSection: section)
  }
  
}