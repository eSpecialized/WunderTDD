//
//  WWunderAPI.swift
//  WunderTDD
//
//  Created by William Thompson on 1/23/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

import UIKit

class WWunderAPI: NSObject {

    static let kWundergroundApiKey = "kWundergroundApiKey"
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    public static func saveApiKey(inApiKey: String) {
        let ud = UserDefaults.standard
        ud.set(inApiKey, forKey: WWunderAPI.kWundergroundApiKey)
        ud.synchronize()
    }
    
    public static func getApiKey() -> String? {
        let ud = UserDefaults.standard
        return ud.value(forKey: WWunderAPI.kWundergroundApiKey) as? String
    }
    
    func fetchWeather(inCity: String, inState: String, completion: @escaping (WeatherJSONStruct?, String?, Error?) -> Void) {
        
        guard let apiKey = WWunderAPI.getApiKey()  else {
            print("Configuration needed for API key")
            
            return
        }
        
        let state = inState.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
        let city = inCity.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
        
        let url = URL(string: "https://api.wunderground.com/api/\(apiKey)/geolookup/conditions/q/\(state)/\(city).json")!
        let request = URLRequest(url: url )
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                let jsonString = String(data: data, encoding: .utf8)
                completion(nil,jsonString,nil)
            }
            
        }
        dataTask.resume()
        
    }
}
