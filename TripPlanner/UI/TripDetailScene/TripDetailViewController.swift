//
//  TripDetailScene.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/29/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit
import CoreData

class TripDetailViewController: UIViewController {
 
  var trip: Trip?
  var coreDataClient: CoreDataClient!
  
  @IBOutlet var noWayPointsView: UIView!
  @IBOutlet var someWayPointsView: UIView!
  var activeView: UIView!
  
  var currentWaypoint: Waypoint?
  var currentContext: NSManagedObjectContext?
  
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
      let (newWaypoint, temporaryContext) = coreDataClient.createObjectInTemporaryContext(Waypoint.self)
      currentWaypoint = newWaypoint
      currentContext = temporaryContext
    }
  }
  
  @IBAction func saveWaypoint(segue:UIStoryboardSegue) {
    if let currentWaypoint = currentWaypoint, let currentContext = currentContext, let trip = trip {
      // refetch the trip in the current context
      // TODO: refactor
      let tripInCurrentContext = currentContext.objectWithID(trip.objectID)
      tripInCurrentContext.addObject(currentWaypoint, forKey:"waypoints")
      try! currentContext.save()
      coreDataClient.saveStack()
    }
  }
  
  @IBAction func cancelWaypointCreation(segue:UIStoryboardSegue) {
    // discard temporary context
    currentContext = nil
  }
  
}