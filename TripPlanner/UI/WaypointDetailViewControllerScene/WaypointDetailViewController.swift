//
//  WaypointDetailViewController.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 8/7/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit
import MapKit

class WaypointDetailViewController: UIViewController {
  
  @IBOutlet var mapView: MKMapView!
  var mapViewDecorator: LocationSearchMapViewDecorator!
  
  var waypoint: Waypoint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapViewDecorator = LocationSearchMapViewDecorator(mapView: mapView)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    guard let selectedWaypoint = waypoint else {
      assertionFailure("WaypointDetailViewController needs trip assigned before viewWillAppear is called")
      return
    }
    
    navigationItem.title = selectedWaypoint.name
  }
  
}