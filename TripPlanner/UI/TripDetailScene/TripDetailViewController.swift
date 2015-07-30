//
//  TripDetailScene.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/29/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit

class TripDetailViewController: UIViewController {
 
  var trip: Trip?
  
  @IBOutlet var noWayPointsView: UIView!
  @IBOutlet var someWayPointsView: UIView!
  var activeView: UIView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.title = trip?.locationDescription
    
    activeView = noWayPointsView
    view.addSubview(activeView)
    activeView.frame = view.frame
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    
    activeView.removeFromSuperview()
  }
  
  @IBAction func saveWaypoint(segue:UIStoryboardSegue) {
    
  }
  
  @IBAction func cancelWaypointCreation(segue:UIStoryboardSegue) {
    
  }
  
}