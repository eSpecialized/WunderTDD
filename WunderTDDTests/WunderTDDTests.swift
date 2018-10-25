//
//  WunderTDDTests.swift
//  WunderTDDTests
//
//  Created by William Thompson on 1/23/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

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
    
        let expectedJSONStruct = expectation(description: "Weather struct wasn't fetched properly, check all settings")
        let bag = DisposeBag()
        let weatherAPI = WWunderAPI()
        _ = weatherAPI.fetch( type: .kWeather ,city: "Portland", state: "OR")
            .subscribe(onNext: { (weatherStruct) in
                XCTAssert(weatherStruct.currentObservation.displayLocation.city == "Portland", "Wrong city returned from API or error")
                XCTAssert(weatherStruct.currentObservation.displayLocation.state == "OR", "Wrong state returned from API or error")
                expectedJSONStruct.fulfill()
            })
            .disposed(by: bag)
        
        waitForExpectations(timeout: 30) { (error) in
            if let error = error {
                print(error)
            }
        }
        
    }
    
    func testWeatherFetchPerformance() {
        // This is an example of a performance test case.
        self.measure {
            let bag = DisposeBag()
            let expectedResponse = expectation(description: "Weather jsonString wasn't fetched properly, check all settings")
            // Put the code you want to measure the time of here.
            let weatherAPI = WWunderAPI()
            _ = weatherAPI.fetch( type: .kWeather ,city: "Portland", state: "OR")
                .subscribe(onNext: { (weatherStruct) in
                    expectedResponse.fulfill()
                })
                .disposed(by: bag)
            
            waitForExpectations(timeout: 30, handler: { (error) in
                if let error = error {
                    print(error)
                }
            })
        }
    }
    
    func testFindIconNames() {
        let weatherAPI = WWunderAPI()
        let hazyurl = weatherAPI.findIconUrlString(iconName: "hazy")
        let rainurl = weatherAPI.findIconUrlString(iconName: "rain")
        let sunnysideupurl = weatherAPI.findIconUrlString(iconName: "sunnysideup")
        XCTAssertNotNil(hazyurl, "Hazy icon URL not found!")
        XCTAssertNotNil(rainurl, "Rain icon URL not found!")
        XCTAssertNil(sunnysideupurl, "Error value returned which is invalid")
        XCTAssertTrue(hazyurl! == "https://icons.wxug.com/i/c/d/hazy.gif", "URL does not match desired for hazy")
        XCTAssertTrue(rainurl! == "https://icons.wxug.com/i/c/d/rain.gif", "URL does not match desired for rain")
    }
}
