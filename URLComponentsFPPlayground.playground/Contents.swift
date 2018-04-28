//: Playground - noun: a place where people can play

//build the project for one of the iPhone Simulators, then come back here to use the play ground - Bill 2018-April
//NOTE: the playground feature only works with cocoapods v 1.3.1 and 1.4.0, use bundle install to get the correct cocoapods version for this feature to work in Xcode 9.2 and 9.3
import UIKit
import RxSwift
import RxCocoa
import RealmSwift

let weatherIconUrlStrings = ["https://icons.wxug.com/i/c/d/chanceflurries.gif",
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

//func findIconUrlString(iconName: String) -> String?
//{
//    var iconStringResult : String?
//
//    let iconName = iconName + ".gif"
//    for thisString in weatherIconUrlStrings {
//        let urlComps = URLComponents(string: thisString)
//        let pathComps = urlComps?.path.components(separatedBy: CharacterSet(charactersIn: "/"))
//        if let theLastComp = pathComps?.last {
//            if theLastComp == iconName {
//                iconStringResult = thisString
//                break
//            }
//        }
//    }
//    return iconStringResult
//}

//first refactor
//func findIconUrlString(iconName: String) -> String?
//{
//    let iconName = iconName + ".gif"
//
//    let results: [String] = weatherIconUrlStrings.filter { weatherStringUrl in
//        let lastComp = URLComponents(string: weatherStringUrl)?.path.components(separatedBy: CharacterSet(charactersIn: "/")).last
//        return lastComp == iconName
//    }
//    return results.first
//}

//second refactor
//func findIconUrlString(iconName: String) -> String?
//{
//    let iconName = iconName + ".gif"
//
//    let results: [String] = weatherIconUrlStrings.filter { weatherStringUrl in
//        let lastComp = URLComponents(string: weatherStringUrl)?.path.components(separatedBy: CharacterSet(charactersIn: "/")).last
//        return lastComp == iconName
//    }
//    return results.first
//}

//third refactor
//extension String {
//    func urlComponentsFromString() -> URLComponents? {
//        return URLComponents(string: self)
//    }
//}
//
//func findIconUrlString(iconName: String) -> String?
//{
//    let iconName = iconName + ".gif"
//
//    let results = weatherIconUrlStrings.filter {
//        let lastComp = $0.urlComponentsFromString()?.path.components(separatedBy: CharacterSet(charactersIn: "/")).last
//        return lastComp == iconName
//    }
//    return results.first
//}

extension String {
    func urlPathComponentsFromString(separator: String) -> [String]? {
        return URLComponents(string: self)?.path.components(separatedBy: CharacterSet(charactersIn: separator))
    }
}

func findIconUrlString(iconName: String) -> String?
{
    let iconName = iconName + ".gif"
    
    let results = weatherIconUrlStrings.filter {
        let lastComp = $0.urlPathComponentsFromString(separator: "/")?.last
        return lastComp == iconName
    }
    return results.first
}


print(findIconUrlString(iconName: "nt_rain")!)
print(findIconUrlString(iconName: "none"))

let observer = Observable.of(1,2,3,4,5)

observer.subscribe(onNext: { value in
  print(value)
})
