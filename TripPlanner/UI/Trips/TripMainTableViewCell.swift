//
//  TripMainTableViewCell.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/21/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import ListKit

class TripMainTableViewCell: UITableViewCell, ListKitCellProtocol {
  
  @IBOutlet weak var destinationLabel: UILabel!
  
  var model: Trip? {
    didSet {
      if let model = model {
        destinationLabel.text = model.locationDescription
      }
    }
  }
  
}