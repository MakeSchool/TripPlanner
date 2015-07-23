//
//  AppDelegate.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/20/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var coreDataClient: CoreDataClient?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    let coreDataStack = CoreDataStack(stackType: .SQLite)
    coreDataClient = CoreDataClient(stack: coreDataStack)

    return true
  }
  
  func applicationWillTerminate(application: UIApplication) {
    coreDataClient?.saveStack()
  }

}

