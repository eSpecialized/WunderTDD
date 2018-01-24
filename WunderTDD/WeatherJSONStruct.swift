//
//  WeatherJSONStruct.swift
//  WunderTDD
//
//  Created by William Thompson on 1/23/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

import Foundation


public struct WeatherJSONStruct: Codable {
    public var currentObservation:currentObservationStruct
    
    enum CodingKeys: String, CodingKey {
        case currentObservation = "current_observation"
    }
}

public struct currentObservationStruct: Codable {
    public var displayLocation: displayLocationStruct
    public var feelslike_c: String
    public var feelslike_f: String
    public var currentWeatherString: String
    public var pressure_in: String
    public var temp_f: Double
    public var temp_c: Double
    public var wind_mph: Double
    
    enum CodingKeys: String, CodingKey {
        case displayLocation = "display_location"
        case currentWeatherString = "weather"
        case feelslike_c
        case feelslike_f
        case pressure_in
        case temp_f
        case temp_c
        case wind_mph
    }
}

public struct displayLocationStruct: Codable {
    public var cityState: String
    public var city: String
    public var state: String
    public var zip: String
    
    enum CodingKeys: String, CodingKey {
        case cityState = "full"
        case city
        case state
        case zip
    }
}
