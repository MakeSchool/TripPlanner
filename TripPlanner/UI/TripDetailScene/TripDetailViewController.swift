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
  @IBOutlet var someWayPointsView: TripDetailView!
  var activeView: UIView!
  
  var currentWaypoint: Waypoint?
  var currentContext: NSManagedObjectContext?
  
  // MARK: View Lifecycle
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    guard let selectedTrip = trip else {
      assertionFailure("TripDetailViewControllerneeds trip assigned before viewWillAppear is called")
      return
    }
    
    navigationItem.title = selectedTrip.locationDescription
    
    if (selectedTrip.waypoints?.count == 0) {
      activeView = noWayPointsView
      view.addSubview(activeView)
    } else {
      someWayPointsView.trip = trip
      activeView = someWayPointsView
      (activeView as? TripDetailView)?.delegate = self
      view.addSubview(activeView)
    }
  
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    
    activeView.removeFromSuperview()
  }
  
  // MARK: Subview Layout
  
  func frameBelowNavigationBar() -> CGRect {
    return CGRect(x: 0, y: topLayoutGuide.length, width: view.bounds.size.width, height: view.bounds.size.height - topLayoutGuide.length)
  }
  
  override func viewDidLayoutSubviews() {
    activeView.frame = frameBelowNavigationBar()
  }
  
  // MARK: Segues
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == Storyboard.Main.TripDetailViewController.Segues.AddWaypointSegue) {
      let addWayPointViewController = segue.destinationViewController as? AddWaypointViewController
      if let addWayPointViewController = addWayPointViewController {
        prepareNewWayPointPresentation(addWayPointViewController)
      }
    } else if (segue.identifier == Storyboard.Main.TripDetailViewController.Segues.ShowWaypointDetails) {
      let waypointDetailViewController = segue.destinationViewController as? WaypointDetailViewController
      if let waypointDetailViewController = waypointDetailViewController {
        waypointDetailViewController.waypoint = currentWaypoint
      }
    }
  }
  
  func prepareNewWayPointPresentation(addWaypointViewController: AddWaypointViewController) {
    let (newWaypoint, temporaryContext) = coreDataClient.createObjectInTemporaryContext(Waypoint.self)
    currentWaypoint = newWaypoint
    currentContext = temporaryContext
    addWaypointViewController.waypoint = newWaypoint
  }
  
  // MARK: Exit Segues
  
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

extension TripDetailViewController: TripDetailViewDelegate {
  
  func tripDetailView(tripDetailView: TripDetailView, selectedWaypoint: Waypoint) {
    currentWaypoint = selectedWaypoint

    performSegueWithIdentifier(Storyboard.Main.TripDetailViewController.Segues.ShowWaypointDetails, sender: self)
  }
  
}