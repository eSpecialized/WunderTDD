# WunderTDD
-----

## Status
-----
I built a forwarding service for the moment for demo purposes on my blog.

Wunderground API has gone private and no free keys are allowed.  I will change over to OpenWeather as a consequence so look to me releasing an Open Source Remade from WunderTDD project. This project will change to remain dormant as a consequence.

[See OpenWeatherMap App for iOS](See https://github.com/eSpecialized/OpenWeatherMapApp/)

[![Build Status](https://travis-ci.org/eSpecialized/WunderTDD.svg?branch=master)](https://travis-ci.org/eSpecialized/WunderTDD)

Wunderground weather TDD Swift

[My Blog post about this App](http://www.blog.willandnora.com/2018/01/24/ios-wunderground-weather-test-driven-design-with-swift-4-and-xctest/)

[Wunderground Logo usage](https://www.wunderground.com/weather/api/d/docs?d=resources/logo-usage-guide)

[Wunderground Weather Icons](https://www.wunderground.com/weather/api/d/docs?d=resources/icon-sets)

[Youtube video showing testing](https://youtu.be/gBEju-zPcjE)




## Synopsis
------
This is a demonstration App of TDD in a Swift App using built-in XCTest.  
I did this to measure the time it takes to prototype out basic functionality, as such some error handling is not handled.  
The premise is that by writing an Application with TDD very little time is used writing actual tests and time is saved for other tasks at all future updates/refactors.  

Technologies utilized:
1. XCTest
2. XCUITest
3. CoreData
4. SwiftyGif CocoaPod
5. Wunderground API calls using URLSession dataTasks
6. Using Codable with structs for JSON, and creating an API module
7. Swift 4.0
8. Xcode 9.2
9. How to share code on GitHub that requires API keys to work, by using UserDefaults to store the API key and a view to configure it by.
10. RxSwift, RxCocoa
 11. Realm for data persistance

## Motivation
------
  * As a way to contribute to open source community, and to demonstrate how easy TDD is to implement in just 6.5 hours in a functional app.  
  * More and more employers want to see projects that feature TDD, including GitHub open source projects. This was one way I can demonstrate those abilities.  
  * I've wanted to write a weather-based application for years.  
  * To solidify XCTest and XCUITest usage in a project.  

## Installation
------
1. Clone this repository
    git clone https://github.com/eSpecialized/WunderTDD.git
    
2. The application runs in the iOS simulator.

3. You will need an API key from weather underground obtainable here <https://www.wunderground.com/weather/api/>

4. Run the Application in the simulator once, click on "Config" on the main screen and in here you will paste the API Key.  
     * First, copy the API key on your mac, paste it with command + V in the simulator, then you double tap twice on the API Key field.  
     * A paste option will show up, and hit paste.  
     * Click back once done.  


## Tests

Click and Hold "Run" to show the wrench "Test" tool. Click that to run the tests sequentially.


## Contributors
------
Feel free to fork this project and make additions and updates.

Please use the following format guidelines when editing the project and source code <http://styleguide.artandlogic.com/home>


## License
------
  See the License file.
  SwiftyGif CocoaPod is MIT licensed <https://cocoapods.org/pods/SwiftyGif>

## Reactive RxSwift
------
  One of the ways to increase robust code in an application, and simplify closures is to use Reactive Swift (RxSwift)
   The idea here is to introduce more Functional Programming techniques and elmination of software bugs by doing so.
   

