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
        tripPlannerClient.fetchTrips {
            if case .Success(let trips) = $0 {
                trips.forEach {
                    let (newTrip, temporaryContext) = self.coreDataClient.createObjectInTemporaryContext(Trip.self)
                    newTrip.configureWithJSONTrip($0)
                    try! temporaryContext.save()
                    self.coreDataClient.saveStack()
                }
            }
        }
    }
    
    func uploadSync() -> Void {
        
    }
    
}

private func defaultTripPlannerClient() -> TripPlannerClient {
    return TripPlannerClient(urlSession: NSURLSession.sharedSession())
}