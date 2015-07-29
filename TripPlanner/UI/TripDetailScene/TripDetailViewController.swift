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
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.title = trip?.locationDescription
  }
  
}