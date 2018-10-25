//
//  WWunderAPI.swift
//  WunderTDD
//
//  Created by William Thompson on 1/23/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire

//https://gist.github.com/alskipp/e71f014c8f8a9aa12b8d8f8053b67d72
func ignoreNil<Wheat>(x: Wheat?) -> Observable<Wheat> {
    return x.map { Observable.just($0) } ?? Observable.empty()
}

class WWunderAPI: NSObject {
  
  public enum WWunderAPIErrors: Error {
    case kNoAPIKey,kHostNoResponse
  }

    fileprivate let bag = DisposeBag()
  
    static fileprivate let kWundergroundApiKey = "kWundergroundApiKey"
    
    fileprivate let fSession = URLSession(configuration: URLSessionConfiguration.default)
    
    public static func saveApiKey(inApiKey: String) {
        let ud = UserDefaults.standard
        ud.set(inApiKey, forKey: WWunderAPI.kWundergroundApiKey)
        ud.synchronize()
    }
    
    public static func getApiKey() -> String {
        let ud = UserDefaults.standard
        if let theVal = ud.value(forKey: WWunderAPI.kWundergroundApiKey) as? String {
            return theVal
        }
        return ""
    }
   
   public static func convert( data: Data?) -> WeatherJSONStruct? {
      var weatherStructure: WeatherJSONStruct?
      if let data = data {
         do {
            let decoder = JSONDecoder()
            weatherStructure = try decoder.decode(WeatherJSONStruct.self, from: data)
         } catch let error {
            print(error)
         }
      }
      return weatherStructure
   }
   
   public enum DownloadType {
      case kWeather
      case kWeatherSatelliteHybridMap
   }
   
  public func fetch( type: DownloadType, city: String, state: String) -> Observable<WeatherJSONStruct> {
        guard
            let stateEncoded = state.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed),
            let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) else {
                return Observable.empty()
            }

        let url = "https://www.blog.willandnora.com/wundertddapi.php?city=\(stateEncoded)&state=\(cityEncoded)"

        return RxAlamofire.requestData(.get, url)
            .debug()
            .map { return WWunderAPI.convert(data: $1) }
            .flatMap(ignoreNil)
    }
    
    public func fetchMap( type: DownloadType, city: String, state: String) -> Observable<UIImage> {
        let apiKey = WWunderAPI.getApiKey()
        guard
            let stateEncoded = state.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed),
            let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) else {
                return Observable.empty()
        }
        
        let url = "https://api.wunderground.com/api/" + apiKey + "/animatedradar/animatedsatellite/q/\(stateEncoded)/\(cityEncoded).gif?num=6&delay=50&interval=30"
        
        
        return RxAlamofire.requestData(.get, url)
            .debug()
            .map { return UIImage.init(gifData: $1) }
            .flatMap(ignoreNil)
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
    func fetchIconData(icon: String) -> Observable<UIImage>
    {
        guard let iconStringResult = findIconUrlString(iconName:icon) else { return Observable.empty() }
        
        return RxAlamofire.requestData(.get, iconStringResult)
            .map { return UIImage.init(gifData: $1) }
            .flatMap(ignoreNil)
    }
}
