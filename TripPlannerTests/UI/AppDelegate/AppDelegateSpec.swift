//
//  AppDelegateSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/23/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit
import Quick
import Nimble
@testable import TripPlanner

class AppDelegateSpec: QuickSpec {
  
  override func spec() {
    
    describe("AppDelegate") {
      
      var appDelegate: AppDelegate!
      
      beforeEach {
        appDelegate = AppDelegate()
      }
      
      describe("when application(_:, didFinishLaunchingWithOptions:) is called") {
        
        it("creates and stores a CoreDataClient") {
          appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
          
          expect(appDelegate.coreDataClient).notTo(beNil())
        }
        
        it("passes the CoreDataClient to the initial view controller") {
          // we need access to AppDelegate of UIApplication because we want to access the root view controller
          let actualAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
          actualAppDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)

          let mainViewController = (actualAppDelegate.window?.rootViewController as! UINavigationController).topViewController as! MainViewController
          
          expect(mainViewController.coreDataClient).notTo(beNil())
        }
        
      }
      
      describe("when applicationWillTerminate is called") {
        
        it("tells the CoreDataClient to save") {
          class CoreDataClientMock: CoreDataClient {
            var called = false
            
            override func saveStack() -> Void {
              called = true
            }
          }

          let stack = CoreDataStack(stackType: .InMemory)
          let coreDataClientMock = CoreDataClientMock(stack: stack)
          
          appDelegate.coreDataClient = coreDataClientMock
          
          let application = UIApplication.sharedApplication()
          appDelegate.applicationWillTerminate(application)
          
          expect(coreDataClientMock.called).to(beTrue())
        }
      }
      
    }
    
  }
  
}