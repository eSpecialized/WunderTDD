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
    
    let fSession = URLSession(configuration: URLSessionConfiguration.default)
    
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
        
        let stateEncoded = inState.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
        let cityEncoded = inCity.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
        
        //this first url looks at all weather stations.
        //let url = URL(string: "https://api.wunderground.com/api/\(apiKey)/geolookup/conditions/q/\(stateEncoded)/\(cityEncoded).json")!
        
        //more general purpose api
        let url = URL(string: "https://api.wunderground.com/api/" + apiKey + "/conditions/q/\(stateEncoded)/\(cityEncoded).json")!
        
        let request = URLRequest(url: url )
        
        let dataTask = fSession.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                
                do {
                    let decoder = JSONDecoder()
                    let jsonStruct = try decoder.decode(WeatherJSONStruct.self, from: data)
                    
                    let jsonString = String(data: data, encoding: .utf8)
                    DispatchQueue.main.async {
                        completion(jsonStruct,jsonString,error)
                    }
                    
                } catch let error {
                    print(error)
                }
                
                
            }
            
        }
        dataTask.resume()
        
    }
    
    let weatherIconUrls = ["https://icons.wxug.com/i/c/d/chanceflurries.gif",
        "https://icons.wxug.com/i/c/d/chancerain.gif",
        "https://icons.wxug.com/i/c/d/chancesleet.gif",
        "https://icons.wxug.com/i/c/d/chancesnow.gif",
        "https://icons.wxug.com/i/c/d/chancetstorms.gif",
        "https://icons.wxug.com/i/c/d/clear.gif",
        "https://icons.wxug.com/i/c/d/cloudy.gif",
        "https://icons.wxug.com/i/c/d/flurries.gif",
        "https://icons.wxug.com/i/c/d/fog.gif",
        "https://icons.wxug.com/i/c/d/hazy.gif",
        "https://icons.wxug.com/i/c/d/mostlycloudy.gif",
        "https://icons.wxug.com/i/c/d/mostlysunny.gif",
        "https://icons.wxug.com/i/c/d/partlycloudy.gif",
        "https://icons.wxug.com/i/c/d/partlysunny.gif",
        "https://icons.wxug.com/i/c/d/sleet.gif",
        "https://icons.wxug.com/i/c/d/rain.gif",
        "https://icons.wxug.com/i/c/d/snow.gif",
        "https://icons.wxug.com/i/c/d/sunny.gif",
        "https://icons.wxug.com/i/c/d/tstorms.gif",
        "https://icons.wxug.com/i/c/d/nt_chanceflurries.gif",
        "https://icons.wxug.com/i/c/d/nt_chancerain.gif",
        "https://icons.wxug.com/i/c/d/nt_chancesleet.gif",
        "https://icons.wxug.com/i/c/d/nt_chancesnow.gif",
        "https://icons.wxug.com/i/c/d/nt_chancetstorms.gif",
        "https://icons.wxug.com/i/c/d/nt_clear.gif",
        "https://icons.wxug.com/i/c/d/nt_cloudy.gif",
        "https://icons.wxug.com/i/c/d/nt_flurries.gif",
        "https://icons.wxug.com/i/c/d/nt_fog.gif",
        "https://icons.wxug.com/i/c/d/nt_hazy.gif",
        "https://icons.wxug.com/i/c/d/nt_mostlycloudy.gif",
        "https://icons.wxug.com/i/c/d/nt_mostlysunny.gif",
        "https://icons.wxug.com/i/c/d/nt_partlycloudy.gif",
        "https://icons.wxug.com/i/c/d/nt_partlysunny.gif",
        "https://icons.wxug.com/i/c/d/nt_sleet.gif",
        "https://icons.wxug.com/i/c/d/nt_rain.gif",
        "https://icons.wxug.com/i/c/d/nt_snow.gif",
        "https://icons.wxug.com/i/c/d/nt_sunny.gif",
        "https://icons.wxug.com/i/c/d/nt_tstorms.gif",
        "https://icons.wxug.com/i/c/d/nt_cloudy.gif",
        "https://icons.wxug.com/i/c/d/nt_partlycloudy.gif"
    ]
    
    func findIconUrlString(iconName: String) -> String?
    {
        var iconStringResult : String?
        
        let iconName = iconName + ".gif"
        for thisString in weatherIconUrls {
            let urlComps = URLComponents(string: thisString)
            let pathComps = urlComps?.path.components(separatedBy: CharacterSet(charactersIn: "/"))
            if let theLastComp = pathComps?.last {
                if theLastComp == iconName {
                    iconStringResult = thisString
                    break
                }
            }
        }
        return iconStringResult
    }
    
    
    func fetchIconData(icon: String, completion: @escaping (Data?, Error?) -> Void )
    {
        if let iconStringResult = findIconUrlString(iconName:icon), let iconUrl = URL(string: iconStringResult)
        {
            let request = URLRequest(url: iconUrl )
            
            let dataTask = fSession.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    completion(data, error)
                }
            }
            dataTask.resume()
        }
    }

    func fetchRadarAndSatGifData(inCity: String, inState: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let apiKey = WWunderAPI.getApiKey()  else {
            print("Configuration needed for API key")
            
            return
        }
        
        let stateEncoded = inState.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
        let cityEncoded = inCity.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!

        let url = URL(string: "https://api.wunderground.com/api/" + apiKey + "/animatedradar/animatedsatellite/q/\(stateEncoded)/\(cityEncoded).gif?num=6&delay=50&interval=30")!
        
        let request = URLRequest(url: url )
        
        let dataTask = fSession.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    completion(data, error)
                }
        }
        dataTask.resume()
    }
}
