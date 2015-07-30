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
  var coreDataClient: CoreDataClient!
  
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
  
  // MARK: Segues
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == Storyboard.Main.TripDetailViewController.Segues.AddWaypointSegue) {
      let waypoint = coreDataClient.createObjectInTemporaryContext(Waypoint.self)
    }
  }
  
  @IBAction func saveWaypoint(segue:UIStoryboardSegue) {
    
  }
  
  @IBAction func cancelWaypointCreation(segue:UIStoryboardSegue) {
    
  }
  
}