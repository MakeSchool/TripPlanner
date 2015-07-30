//
//  CoreDataExtension.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/30/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import CoreData

extension NSManagedObject {
  func addObject(value: NSManagedObject, forKey: String) {
    self.willChangeValueForKey(forKey, withSetMutation: NSKeyValueSetMutationKind.UnionSetMutation, usingObjects: NSSet(object: value) as Set<NSObject>)
    let items = self.mutableSetValueForKey(forKey);
    items.addObject(value)
    self.didChangeValueForKey(forKey, withSetMutation: NSKeyValueSetMutationKind.UnionSetMutation, usingObjects: NSSet(object: value) as Set<NSObject>)
  }
}