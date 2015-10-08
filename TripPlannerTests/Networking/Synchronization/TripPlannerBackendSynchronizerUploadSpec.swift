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
        
          // 1) Create Deleted Trips
          let deletedTripServerID = "0"
          let deletedTrip = Trip(context: client.context)
          deletedTrip.serverID = deletedTripServerID
          client.saveStack()

          client.markTripAsDeleted(deletedTrip)
          client.saveStack()
          
          // 2) Create New Trips
          let newTrip = Trip(context: client.context)
          newTrip.locationDescription = "San Francisco"
          client.saveStack()
          
          let (postRequests, deleteRequests) = tripPlannerBackendSynchronizer.generateUploadRequests()
          
          expect(postRequests.count).to(equal(1))
          expect(postRequests[0].resource.
          
          expect(deleteRequests.count).to(equal(1))
          expect(deleteRequests[0].resource.path).to(equal("trip/\(deletedTripServerID)"))
        }
        
      }
      
    }
    
  }
  
}
