//
//  TripPlannerBackendSynchronization.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 9/9/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation

struct TripPlannerBackendSynchronizer {
    
    var tripPlannerClient: TripPlannerClient
    var coreDataClient: CoreDataClient
    
    init(tripPlannerClient: TripPlannerClient = defaultTripPlannerClient(), coreDataClient: CoreDataClient) {
        self.tripPlannerClient = tripPlannerClient
        self.coreDataClient = coreDataClient
    }
        
    func downloadSync() -> Void {
        let allTrips = tripPlannerClient.fetchTrips {
            $0
            let (newTrip, temporaryContext) = self.coreDataClient.createObjectInTemporaryContext(Trip.self)
            newTrip.locationDescription = "Stuttgart"
            try! temporaryContext.save()
            self.coreDataClient.saveStack()
        }
    }
    
    func uploadSync() -> Void {
        
    }
    
}

private func defaultTripPlannerClient() -> TripPlannerClient {
    return TripPlannerClient(urlSession: NSURLSession.sharedSession())
}