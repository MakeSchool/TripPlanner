//
//  CoreDataStack.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/20/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import Quick
import Nimble
import CoreData
@testable import TripPlanner

class CoreDataStackSpec: QuickSpec {
  
  override func spec() {
    describe("initialization with memory stack") {
      
      let stack = CoreDataStack(stackType: .InMemory)
      
      it("provides a managed object context") {
        expect(stack.managedObjectContext).toNot(beNil())
      }
      
      it("stores objects in the managed object context") {
        let trip = Trip(context: stack.managedObjectContext)
        trip.locationDescription = "San Francisco"
        stack.save()
      
        expect(trip.hasPersistentChangedValues).to(beFalse())
      }
      
    }
    
    describe("initialization with SQLite stack") {
      
      let stack = CoreDataStack(stackType: .SQLite)
      
      it("provides a managed object context") {
        expect(stack.managedObjectContext).toNot(beNil())
      }
      
    }
  }
  
}