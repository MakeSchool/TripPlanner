//
//  TripPlannerManagedObject.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/22/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import CoreData

protocol TripPlannerManagedObject {
  
  init(context: NSManagedObjectContext)
  
}