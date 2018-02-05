//
//  WWunderAPI.swift
//  WunderTDD
//
//  Created by William Thompson on 1/23/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

import UIKit

/**
This class performs functions to fetch the weather from Wunderground using its API key.
 
 - Author: William Thompson
 
 - Copyright: © 2018 William Thompson. All rights reserved.
 
 - License: MIT licensed, see the LICENSE file for details.
 
 */
class WWunderAPI: NSObject {

    static fileprivate let kWundergroundApiKey = "kWundergroundApiKey"
    
    fileprivate let fSession = URLSession(configuration: URLSessionConfiguration.default)
    
    public static func saveApiKey(inApiKey: String) {
        let ud = UserDefaults.standard
        ud.set(inApiKey, forKey: WWunderAPI.kWundergroundApiKey)
        ud.synchronize()
    }
    
    public static func getApiKey() -> String? {
        let ud = UserDefaults.standard
        return ud.value(forKey: WWunderAPI.kWundergroundApiKey) as? String
    }
    
/**
This function fetches the Weather in the background.
     
- parameters:
    - inCity: is a full city name with spaces permitted.
    - inState: is a state two letter designation. OR = Oregon
    - completion: a block of code that feeds back three additional paramters. A WeatherJSONStruct? structure for weather information, all JSON response as a String?, Error? any errors encountered
     
Returns through the completion block WeatherJSONStruct (Optional), JSON Response as a String (Optional), and Error if any (Optional).
*/
    public func fetchWeather(inCity: String, inState: String, completion: @escaping (WeatherJSONStruct?, String?, Error?) -> Void) {
        
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
    
    fileprivate let weatherIconUrlStrings = ["https://icons.wxug.com/i/c/d/chanceflurries.gif",
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
    
   /**
   This function finds a WeatherUnderground icon URL String for the weather type based on input strings such as "rain" "sunny" "snow" etc.
    
   - parameters:
       - iconName: is a subString of the icon name. rain, sunny, snow, etc.
    
   - returns:  nil if not found, or a String? result of icon url as a string.
   */
    func findIconUrlString(iconName: String) -> String?
    {
        return weatherIconUrlStrings.filter {
            $0.urlPathComponentsFromString(separator: "/")?.last == iconName + ".gif"
            }.first
    }
    
   /**
    This function downloads a WeatherUnderground icon using a URL String from findIconUrlString
    
    - parameters:
       - icon: is a string of the icon URL.
       - completion: a block of code that returns the Data? or Error? received from the remote host
    */
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

   /**
    This function downloads a WeatherUnderground Radar Satellite gif using a city and state.
    
    - parameters:
       - inCity: A USA city allowing spaces
       - inState: A two letter code representing one of the USA states
       - completion: a block of code that returns the Data? or Error? received from the remote host
    */
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
