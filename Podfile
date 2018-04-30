# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'alps-ios-TicketingApp' do
# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

# Pods for alps-ios-TicketingApp
pod 'SkyFloatingLabelTextField', '~> 3.0'
pod 'PKHUD', '~> 5.0'
pod 'Kingfisher', '~> 4.0'

pod 'Matchmore', '~> 0.7'

pod 'Fabric'
pod 'Crashlytics'

pod 'SwiftFormat/CLI'

post_install do |installer|
    # Your list of targets here.
    myTargets = ['SkyFloatingLabelTextField']
    
    installer.pods_project.targets.each do |target|
        if myTargets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end

end
