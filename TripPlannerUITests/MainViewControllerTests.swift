//
//  TripPlannerUITests.swift
//  TripPlannerUITests
//
//  Created by Benjamin Encz on 7/20/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import XCTest

class TripPlannerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddButton() {
        XCUIApplication().navigationBars["TripPlanner.MainView"].buttons["Add"].tap()
        
        let navigationItemTitle = XCUIApplication().navigationBars["Add Trip"].staticTexts["Add Trip"]
        
        XCTAssert(navigationItemTitle.exists)
    }
    
}