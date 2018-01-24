//
//  WunderTDDUITests.swift
//  WunderTDDUITests
//
//  Created by William Thompson on 1/23/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

import XCTest

class WunderTDDUITests: XCTestCase {
    
    let fApp = XCUIApplication()
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        fApp.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddFunctionality() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let locationString = "Florence, OR"
        
        addUIInterruptionMonitor(withDescription: "Add Location") { (alert) -> Bool in
            alert.textFields.firstMatch.typeText(locationString)
            alert.buttons["Ok"].tap()
            return true
        }
        
        let cellCountOrig = fApp.tables.firstMatch.cells.count
        
        //start the alert add process
        fApp.buttons["Add"].tap()
        
        //activate the monitor created above
        fApp.tap()
        
        print(fApp.tables.firstMatch.cells.debugDescription)
        let locationStringTest = fApp.tables.firstMatch.cells.staticTexts[locationString]
        //let portlandOR = fApp.tables.firstMatch.cells.staticTexts["location"]
        XCTAssert(locationStringTest.waitForExistence(timeout: 5), "Failed to find the expected City, State in the table cells")
        XCTAssert(locationStringTest.label == locationString, "Location failed to populate properly")
        
        var cellCountNow = fApp.tables.firstMatch.cells.count
        XCTAssert(cellCountNow > cellCountOrig , "Failed to add a new cell to the table")
        
        let windLabel = fApp.staticTexts["wind"]
        XCTAssert(windLabel.waitForExistence(timeout: 30), "Error waiting for wind to show up")
        
        for i in 0..<cellCountNow {
            let thisCell = fApp.tables.firstMatch.cells.element(boundBy: i)
            let conditionsLabel = thisCell.staticTexts["conditions"]
            XCTAssert(conditionsLabel.label != "...", "Current conditions didn't populate in the UI error")
        }
        
        //remove the florence cell which is now at top
        fApp.tables.firstMatch.cells.firstMatch.swipeLeft()
        fApp.buttons["Delete"].tap()
        cellCountNow = fApp.tables.firstMatch.cells.count
        
        XCTAssert(cellCountNow == cellCountOrig, "Failed to remove the newly added cell")
    }
    
}
