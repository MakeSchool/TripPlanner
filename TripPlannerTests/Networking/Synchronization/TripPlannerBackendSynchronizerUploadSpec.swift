//
//  TripPlannerBackendSynchronizerUploadSpec.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 10/8/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Quick
import Nimble
import CoreLocation

@testable import TripPlanner

class TripPlannerBackendSynchronizerUploadSpec: QuickSpec {

  override func spec() {
  
    describe("TripPlannerBackendSynchronizer") {

      context("generateUploadRequests") {
        
        it("generates requests for deleted, updated and added trips") {
          let stack = CoreDataStack(stackType: .InMemory)
          let client = CoreDataClient(stack: stack)
          let tripPlannerBackendSynchronizer = TripPlannerBackendSynchronizer(coreDataClient: client)
          
          let (trip, temporaryContext) = client.createObjectInTemporaryContext(Trip)
          trip.serverID = "0"
          try! temporaryContext.save()
          client.saveStack()
          
          client.markTripAsDeleted(trip)
          client.saveStack()
          
          let requests = tripPlannerBackendSynchronizer.generateUploadRequests()
          
          expect(requests.count).to(equal(1))
          expect(requests[0].resource.path).to(equal("trip/\(trip.serverID!)"))
        }
        
      }
      
    }
    
  }
  
}
