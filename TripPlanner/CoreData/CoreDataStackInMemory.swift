//
//  CoreDataStackInMemory.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/20/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStackInMemory: CoreDataStack {
  
  private(set) var managedObjectContext: NSManagedObjectContext?
  private var privateManagedObjectContext: NSManagedObjectContext?
  
  init() {
    setupStack()
  }
  
  func setupStack() {
    if (managedObjectContext != nil) { return }
    
    let modelURL = NSBundle.mainBundle().URLForResource("TripPlanner", withExtension: "momd")!
    let model = NSManagedObjectModel(contentsOfURL: modelURL)
    let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
    
    managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    
    managedObjectContext?.parentContext = privateManagedObjectContext
    privateManagedObjectContext?.persistentStoreCoordinator = storeCoordinator
    
    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
    let failureReason = "There was an error creating or loading the application's saved data."
    do {
      try storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
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
    
  lazy var applicationDocumentsDirectory: NSURL = {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.makeschool.TripPlanner" in the application's documents Application Support directory.
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1]
    }()
  
}