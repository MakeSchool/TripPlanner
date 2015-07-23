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
  var coreDataStack: CoreDataStack!
  var newTrip: Trip?
  
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
    
    if (coreDataClient == nil) {
      coreDataStack = CoreDataStack(stackType: .SQLite)
      coreDataClient = CoreDataClient(context: coreDataStack.managedObjectContext)
    }
    
    trips = coreDataClient.allTrips()
    
    self.tableView.dataSource = arrayDataSource
  }
  
  // MARK: Segues
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "AddNewTrip") {
      newTrip = coreDataClient.createObjectInTemporaryContext(Trip.self)
    }
  }
  
  @IBAction func saveTrip(segue:UIStoryboardSegue) {
    try! newTrip?.managedObjectContext?.save()
    coreDataStack.save()
  }
  
  @IBAction func cancelTripCreation(segue:UIStoryboardSegue) {
    
  }
  
}