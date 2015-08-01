//
//  TripDetailView.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/31/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit
import ListKit

class WaypointTableViewCell: UITableViewCell, TableViewCellProtocol {
  var model: Waypoint? {
    didSet {
      if let model = model {
        self.textLabel!.text = model.name
      }
    }
  }
}

class TripDetailView: UIView {
  
  @IBOutlet var tableView: UITableView!
  var arrayDataSource: ArrayDataSource<WaypointTableViewCell, Waypoint>!
  
  var trip: Trip? {
    didSet {
      if let trip = trip {
        // TODO: replace dummy implementation
        let waypointsArray = trip.waypoints?.sort { $0;$1; return true } as? [Waypoint]
        
        if let waypointsArray = waypointsArray {
          arrayDataSource = ArrayDataSource(array: waypointsArray, cellType:WaypointTableViewCell.self)
          tableView.dataSource = arrayDataSource
        }
      }
    }
  }

}

