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
import DVR

@testable import TripPlanner

class TripPlannerBackendSynchronizerUploadSpec: QuickSpec {

  override func spec() {
  
    describe("TripPlannerBackendSynchronizer") {

      context("generateUploadRequests") {
        
        it("generates requests for deleted, updated and added trips") {
          let stack = CoreDataStack(stackType: .InMemory)
          let client = CoreDataClient(stack: stack)
          let tripPlannerBackendSynchronizer = TripPlannerBackendSynchronizer(coreDataClient: client)
        
          // 1) Create Deleted Trip
          let deletedTripServerID = "0"
          let deletedTrip = Trip(context: client.context)
          deletedTrip.serverID = deletedTripServerID
          client.saveStack()

          client.markTripAsDeleted(deletedTrip)
          client.saveStack()
          
          // 2) Create New Trip
          let newTrip = Trip(context: client.context)
          newTrip.locationDescription = "San Francisco"
          client.saveStack()
          
          // 3) Create Updated Trip
          let updatedTrip = Trip(context: client.context)
          updatedTrip.locationDescription = "San Francisco"
          updatedTrip.serverID = "10"
          updatedTrip.lastUpdate = 1000
          // set lastSync timestamp prior to lastUpdate timestamp of trip -> triggers a PUT request
          client.syncInformation().lastSyncTimestamp = 10
          client.saveStack()
          
          let (postRequests, updateRequests, deleteRequests) = tripPlannerBackendSynchronizer.generateUploadRequests()
          
          expect(postRequests.count).to(equal(1))
          expect(postRequests[0].resource.requestBody).notTo(beNil())
          
          expect(updateRequests.count).to(equal(1))
          expect(updateRequests[0].resource.requestBody).notTo(beNil())
          
          expect(deleteRequests.count).to(equal(1))
          expect(deleteRequests[0].resource.path).to(equal("trip/\(deletedTripServerID)"))
        }
        
      }
      
      context("uploadSync") {
        
        it("syncs newly created trips and retrieves and stores serverID") {
          let stack = CoreDataStack(stackType: .InMemory)
          let client = CoreDataClient(stack: stack)
          let session = Session(cassetteName: "trip_planner_post_trip", testBundle: NSBundle.mainBundle())

          let tripPlannerClient = TripPlannerClient(urlSession: session)
          let tripPlannerBackendSynchronizer = TripPlannerBackendSynchronizer(tripPlannerClient: tripPlannerClient, coreDataClient: client)
          
          let newTrip = Trip(context: client.context)
          newTrip.locationDescription = "San Francisco"
          
          // pin `lastUpdate' to specified time stamp so it matches recorded DVR request
          newTrip.parsing = true
          newTrip.lastUpdate = 466117081
          
          client.saveStack()
          
          waitUntil { done in
            tripPlannerBackendSynchronizer.uploadSync {
              let syncedTrip = client.context.objectWithID(newTrip.objectID) as! Trip
              if syncedTrip.serverID != nil {
                done()
              }
            }
          }
        }
        
      }
      
    }
    
  }
  
}