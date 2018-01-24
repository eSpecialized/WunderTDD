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
        
        let cellCountNow = fApp.tables.firstMatch.cells.count
        XCTAssert(cellCountNow > cellCountOrig , "Failed to add a new cell to the table")
        
        let windLabel = fApp.staticTexts["wind"]
        XCTAssert(windLabel.waitForExistence(timeout: 30), "Error waiting for wind to show up")
        
        for i in 0..<cellCountNow {
            let thisCell = fApp.tables.firstMatch.cells.element(boundBy: i)
            let conditionsLabel = thisCell.staticTexts["conditions"]
            XCTAssert(conditionsLabel.label != "...", "Current conditions didn't populate in the UI error")
        }
        

    }
    
    func testDetailFunctionality() {
        
        let locationString = "Florence, OR"
        
        if let thisCell = supportFindCellByLocationLabel(location: locationString) {
            thisCell.tap()
        }
        
        //check navbar title, if the accessibility identifier isn't set, then it will have the title
        let navBarIdent = fApp.navigationBars.element.identifier
        XCTAssert(navBarIdent == locationString, "Failed to open proper cell row for this location")
        
        
        //in the detail view, we have a label and a radar view
        let radarview = fApp.images["radar"]
        XCTAssert(radarview.waitForExistence(timeout: 10), "Radar view didn't show up error")
        
        let conditions = fApp.staticTexts["conditions"]
        XCTAssert(conditions.waitForExistence(timeout: 10), "Failed to find conditions")
        XCTAssertFalse(conditions.label == "...", "Conditions Label is default value error")
    }
    
    func testPersistenceAndDelete() {
        //remove the florence cell which is now at top
        let locationString = "Florence, OR"
        let cellCountOrig = fApp.tables.firstMatch.cells.count
        
        
        if let thisCell = supportFindCellByLocationLabel(location: locationString) {
            thisCell.swipeLeft()
            fApp.buttons["Delete"].tap()
        } else {
            XCTAssert(false, "Failed to find the cell persisting across application launches")
        }
        
        let cellCountNow = fApp.tables.firstMatch.cells.count
        
        XCTAssert(cellCountNow < cellCountOrig, "Failed to remove the cell")
    }
    
    func supportFindCellByLocationLabel(location: String) -> XCUIElement?
    {
        let cellCount = fApp.tables.firstMatch.cells.count
        
        for i in 0..<cellCount {
            let thisCell = fApp.tables.firstMatch.cells.element(boundBy: i)
            let searchLabel = thisCell.staticTexts[location]
            if searchLabel.exists {
                return thisCell
            }
        }
        return nil
    }
    
}
