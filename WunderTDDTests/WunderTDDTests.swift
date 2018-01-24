//
//  WunderTDDTests.swift
//  WunderTDDTests
//
//  Created by William Thompson on 1/23/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

import XCTest
@testable import WunderTDD

class WunderTDDTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchWeather() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    
        let expectedJSONString = expectation(description: "Weather jsonString wasn't fetched properly, check all settings")
        let expectedJSONStruct = expectation(description: "Weather struct wasn't fetched properly, check all settings")
        
        let weatherAPI = WWunderAPI()
        weatherAPI.fetchWeather(inCity: "Portland", inState: "OR") { (WeatherStruct: WeatherJSONStruct?, jsonString: String?, error: Error?) in
            
            if let jsonString = jsonString {
                print(jsonString)
                expectedJSONString.fulfill()
            }
            
            if let weatherStruct = WeatherStruct {
                
                XCTAssert(weatherStruct.currentObservation.displayLocation.city == "Portland", "Wrong city returned from API or error")
                
                XCTAssert(weatherStruct.currentObservation.displayLocation.state == "OR", "Wrong state returned from API or error")
                
                
                expectedJSONStruct.fulfill()
            }
            
        }
        
        waitForExpectations(timeout: 30) { (error) in
            if let error = error {
                print(error)
            }
        }
        
    }
    
    func testWeatherFetchPerformance() {
        // This is an example of a performance test case.
        self.measure {
            let expectedJSONString = expectation(description: "Weather jsonString wasn't fetched properly, check all settings")
            // Put the code you want to measure the time of here.
            let weatherAPI = WWunderAPI()
            weatherAPI.fetchWeather(inCity: "Salem", inState: "OR") { (WeatherStruct: WeatherJSONStruct?, jsonString: String?, error: Error?) in
                
                if let jsonString = jsonString {
                    print(jsonString)
                    expectedJSONString.fulfill()
                }
            }
            
            waitForExpectations(timeout: 30, handler: { (error) in
                if let error = error {
                    print(error)
                }
            })
        }
    }
    
}