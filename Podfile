# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'alps-ios-TicketingApp' do
# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

  # Pods for alps-ios-TicketingApp
#pod 'Alps', :git => 'https://github.com/MatchMore/alps-ios-api.git', :tag => '0.4.0'
#pod 'AlpsSDK', :git => 'https://github.com/MatchMore/alps-ios-sdk.git', :tag => ‘0.4.2’
pod 'Alps', :path => '../alps-ios-api'
pod 'AlpsSDK', :path => '../alps-ios-sdk' 
pod 'SkyFloatingLabelTextField', '~> 3.0'
pod 'PKHUD', '~> 5.0'
pod 'Kingfisher', '~> 4.0'

post_install do |installer|
    # Your list of targets here.
    myTargets = ['SkyFloatingLabelTextField', 'SwiftWebSocket']
    
    installer.pods_project.targets.each do |target|
        if myTargets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end

end
