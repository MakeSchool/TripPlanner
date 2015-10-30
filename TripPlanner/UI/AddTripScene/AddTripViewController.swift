//
//  AddTripScene.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/29/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit

class AddTripViewController: UIViewController {
 
  var currentTrip: Trip!
  
  @IBOutlet var tripTitleTextField: UITextField!
  
  @IBAction func tripTitleChanged(sender: AnyObject) {
    currentTrip.locationDescription = tripTitleTextField.text
  }
}