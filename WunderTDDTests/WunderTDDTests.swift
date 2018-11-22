//
//  WunderTDDTests.swift
//  WunderTDDTests
//
//  Created by William Thompson on 1/23/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

import Mockingjay
import RxSwift
import RxTest
@testable import WunderTDD
import XCTest

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

    let mockPortlandWeatherJSONResponse = """
{
"response": {
"version": "0.1",
"termsofService": "http://www.wunderground.com/weather/api/d/terms.html",
"features": {
"conditions": 1
}
},
"current_observation": {
"image": {
"url": "http://icons.wxug.com/graphics/wu2/logo_130x80.png",
"title": "Weather Underground",
"link": "http://www.wunderground.com"
},
"display_location": {
"full": "Portland, OR",
"city": "Portland",
"state": "OR",
"state_name": "Oregon",
"country": "US",
"country_iso3166": "US",
"zip": "97201",
"magic": "1",
"wmo": "99999",
"latitude": "45.50999832",
"longitude": "-122.69000244",
"elevation": "99.4"
},
"observation_location": {
"full": "Portland, Oregon",
"city": "Portland",
"state": "Oregon",
"country": "US",
"country_iso3166": "US",
"latitude": "45.51",
"longitude": "-122.68",
"elevation": "200 ft"
},
"estimated": {},
"station_id": "KORPORTL1164",
"observation_time": "Last Updated on November 22, 11:47 AM PST",
"observation_time_rfc822": "Thu, 22 Nov 2018 11:47:00 -0800",
"observation_epoch": "1542916020",
"local_time_rfc822": "Thu, 22 Nov 2018 11:48:08 -0800",
"local_epoch": "1542916088",
"local_tz_short": "PST",
"local_tz_long": "America/Los_Angeles",
"local_tz_offset": "-0800",
"weather": "Rain",
"temperature_string": "49.2 F (9.6 C)",
"temp_f": 49.2,
"temp_c": 9.6,
"relative_humidity": "87%",
"wind_string": "From the NE at 1 MPH Gusting to 2.0 MPH",
"wind_dir": "NE",
"wind_degrees": 47,
"wind_mph": 1,
"wind_gust_mph": "2.0",
"wind_kph": 1.6,
"wind_gust_kph": "3.2",
"pressure_mb": "1003",
"pressure_in": "29.62",
"pressure_trend": "-",
"dewpoint_string": "46 F (8 C)",
"dewpoint_f": 46,
"dewpoint_c": 8,
"heat_index_string": "NA",
"heat_index_f": "NA",
"heat_index_c": "NA",
"windchill_string": "49 F (10 C)",
"windchill_f": "49",
"windchill_c": "10",
"feelslike_string": "49 F (10 C)",
"feelslike_f": "49",
"feelslike_c": "10",
"visibility_mi": "10.0",
"visibility_km": "16.1",
"solarradiation": "--",
"UV": "1",
"precip_1hr_string": "0.02 in ( 1 mm)",
"precip_1hr_in": "0.02",
"precip_1hr_metric": " 1",
"precip_today_string": "0.11 in (3 mm)",
"precip_today_in": "0.11",
"precip_today_metric": "3",
"icon": "rain",
"icon_url": "http://icons.wxug.com/i/c/k/rain.gif",
"forecast_url": "http://www.wunderground.com/US/OR/Portland.html",
"history_url": "http://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=KORPORTL1164",
"ob_url": "http://www.wunderground.com/cgi-bin/findweather/getForecast?query=45.512497,-122.684151",
"nowcast": ""
}
}
"""

    // This Test is more comprehensive. ensuring all values are fetched that are desired. Decoding works etc.
    func testFetchWeatherMock() {
        guard let mockData = mockPortlandWeatherJSONResponse.data(using: .utf8)
            else { XCTFail("Failed to get data"); return }
        stub(uri("https://www.blog.willandnora.com/wundertddapi.php?city=OR&state=Portland"), jsonData(mockData))
        let expectedJSONStruct = expectation(description: "Weather struct wasn't fetched properly, check all settings")
        let bag = DisposeBag()
        let weatherAPI = WWunderAPI()
        _ = weatherAPI.fetch( type: .kWeather ,city: "Portland", state: "OR")
            .subscribe(onNext: { (w) in
                XCTAssertEqual(w.currentObservation.displayLocation.city , "Portland")
                XCTAssertEqual(w.currentObservation.displayLocation.state , "OR")
                XCTAssertEqual(w.currentObservation.feelslike_f, "49")
                XCTAssertEqual(w.currentObservation.feelslike_c, "10")
                XCTAssertEqual(w.currentObservation.pressure_in, "29.62")
                XCTAssertEqual(w.currentObservation.wind_mph, 1)
                expectedJSONStruct.fulfill()
            })
            .disposed(by: bag)

        waitForExpectations(timeout: 30) { (error) in
            if let error = error {
                print(error)
            }
        }
    }

}
