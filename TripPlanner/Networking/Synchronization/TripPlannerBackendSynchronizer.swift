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
    
    init(tripPlannerClient: TripPlannerClient) {
        self.tripPlannerClient = tripPlannerClient
    }
    
    init() {
        let defaultTripPlannerClient = TripPlannerClient(urlSession: NSURLSession.sharedSession())
        self.init(tripPlannerClient: defaultTripPlannerClient)
    }
    
    func downloadSync() -> Void {
        let allTrips = tripPlannerClient.fetchTrips { $0 }
    }
    
    func uploadSync() -> Void {
        
    }
    
}