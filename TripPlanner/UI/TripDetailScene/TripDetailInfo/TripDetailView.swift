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

protocol TripDetailViewDelegate: class {
  
  func tripDetailView(tripDetailView: TripDetailView, selectedWaypoint: Waypoint)
  
}

class TripDetailView: UIView {
  
  @IBOutlet var tableView: UITableView!
  var arrayDataSource: ArrayDataSource<WaypointTableViewCell, Waypoint>!
  weak var delegate: TripDetailViewDelegate?
  
  var trip: Trip? {
    didSet {
      if let trip = trip {
        // TODO: replace dummy implementation
        let waypointsArray = trip.waypoints?.sort { $0;$1; return true } as? [Waypoint]
        
        if let waypointsArray = waypointsArray {
          arrayDataSource = ArrayDataSource(array: waypointsArray, cellType:WaypointTableViewCell.self)
          tableView.dataSource = arrayDataSource
          tableView.delegate = self
        }
      }
    }
  }
}

extension TripDetailView: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let selectedWaypoint = arrayDataSource.array[indexPath.row]
    delegate?.tripDetailView(self, selectedWaypoint: selectedWaypoint)
  }
  
}

