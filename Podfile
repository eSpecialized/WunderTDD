platform :ios, '11.0'
use_frameworks!
  
source 'https://github.com/CocoaPods/Specs.git'

def allPods
   pod 'SwiftyGif', '~> 4.2'
   pod 'RxSwift', '~> 4.3.1'
   pod 'RxCocoa', '~> 4.3.1'
   pod 'RealmSwift', '~> 3.11.1'
   pod 'RxAlamofire', '4.3.0'
end
   
target 'WunderTDD' do
    allPods
end

target 'WunderTDDTests' do
   inherit! :search_paths
   allPods
   pod 'RxTest', '4.3.1'
end

target 'WunderTDDUITests' do
   inherit! :search_paths
   allPods
   pod 'RxTest', '4.3.1'
end

swift4 = ['SwiftyGif','RxSwift','RxCocoa','Realm','RealmSwift']

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if swift4.include?(target.name)
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
        end
    end
end
