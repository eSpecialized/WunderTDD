platform :ios, '11.0'
use_frameworks!
  
source 'https://github.com/CocoaPods/Specs.git'

plugin 'cocoapods-binary'

def allPods
   pod 'SwiftyGif', '~> 4.2', :binary => true
   pod 'RxSwift', '~> 4.4.0', :binary => true
   pod 'RxCocoa', '~> 4.4.0', :binary => true
   pod 'RealmSwift', '~> 3.11.2', :binary => true
   pod 'RxAlamofire', '~> 4.3.0', :binary => true
   pod 'SnapKit', '~> 4.2'
   pod 'Log4swift'
end
   
target 'WunderTDD' do
    allPods
    pod 'SwiftLint', '~> 0.28.0'
end

target 'WunderTDDTests' do
   inherit! :search_paths
   allPods
   pod 'RxTest', '4.4.0', :binary => true
   pod 'Mockingjay', :binary => true
end

target 'WunderTDDUITests' do
   inherit! :search_paths
   allPods
   pod 'RxTest', '4.4.0', :binary => true
   pod 'Mockingjay', :binary => true
end

swift4 = ['SwiftyGif','RxSwift','RxCocoa','Realm','RealmSwift','RxTest','RxAlamofire','Alamofire']

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if swift4.include?(target.name)
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
        end
    end
end
