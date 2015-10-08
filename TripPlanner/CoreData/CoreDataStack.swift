//
//  CoreDataStackInMemory.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/20/15.
//  Copyright © 2015 Make School. All rights reserved.
//

// Structure is inspired by: http://martiancraft.com/blog/2015/03/core-data-stack/, Thanks!

import Foundation
import CoreData

enum CoreDataStackType {
  case InMemory, SQLite
}

class CoreDataStack {
  
  private(set) var managedObjectContext: NSManagedObjectContext
    
  private var privateManagedObjectContext: NSManagedObjectContext
  private var storeCoordinator: NSPersistentStoreCoordinator!
  private var stackType: CoreDataStackType
  
  lazy var applicationDocumentsDirectory: NSURL = {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.makeschool.TripPlanner" in the application's documents Application Support directory.
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1]
    }()
  
  init(stackType: CoreDataStackType) {
    self.stackType = stackType

    let modelURL = NSBundle.mainBundle().URLForResource("TripPlanner", withExtension: "momd")!
    let model = NSManagedObjectModel(contentsOfURL: modelURL)
    storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
    
    managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    
    managedObjectContext.parentContext = privateManagedObjectContext
    privateManagedObjectContext.persistentStoreCoordinator = storeCoordinator
    
    self.setupPersistentStore()
  }

  private func setupPersistentStore() {
    let failureReason = "There was an error creating or loading the application's saved data."
    do {
      switch (stackType) {
      case .InMemory:
        try storeCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
      case .SQLite:
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        try storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
      }
    } catch {
      // Report any error we got.
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = failureReason
      
      dict[NSUnderlyingErrorKey] = error as NSError
      let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      // Replace this with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      abort()
    }
  }

  func save() {
    if (!privateManagedObjectContext.hasChanges && !managedObjectContext.hasChanges) {
      return
    }
    
    managedObjectContext.performBlockAndWait { () -> Void in
    
      // catch-all clause necessary, due to bug in Swift 2. See: https://openradar.appspot.com/21669303
      do {
        try self.managedObjectContext.save()
      } catch let error as NSError {
        assertionFailure("Error saving context: \(error), \(error.userInfo)")
      } catch {
        assertionFailure("Undefined error")
      }
      
      self.privateManagedObjectContext.performBlock({ () -> Void in
        do {
          try self.privateManagedObjectContext.save()
        } catch let error as NSError {
          assertionFailure("Error saving context: \(error), \(error.userInfo)")
        } catch {
          assertionFailure("Undefined error")
        }
      })
    }
  }
  
}