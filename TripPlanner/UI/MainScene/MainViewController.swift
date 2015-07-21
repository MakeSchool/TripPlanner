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
  
  var arrayDataSource :ArrayDataSource<TripMainTableViewCell, Trip>?
  
  var trips: [Trip]? {
    didSet {
      if let trips = trips {
        let nib = UINib(nibName: "TripMainTableViewCell", bundle: NSBundle.mainBundle())
        arrayDataSource = ArrayDataSource(array: trips, cellType: TripMainTableViewCell.self, nib: nib)
      }
    }
  }
  
  override func viewDidLoad() {
    let stack = CoreDataStack(stackType: .SQLite)
    let trip = Trip(context: stack.managedObjectContext)
    trip.locationDescription = "Frankfurt"
    
    stack.save()
    
    self.trips = try! stack.managedObjectContext.executeFetchRequest(NSFetchRequest(entityName: "Trip")) as? [Trip]
    
    self.tableView.dataSource = arrayDataSource
  }
  
}