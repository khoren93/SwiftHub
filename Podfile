# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

use_frameworks!
inhibit_all_warnings!

target 'SwiftHub' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    # Pods for SwiftHub

    # Networking
    pod 'Moya/RxSwift', '14.0.0-beta.2'  # https://github.com/Moya/Moya
    pod 'Apollo', '0.19.0'  # https://github.com/apollographql/apollo-ios

    # Rx Extensions
    pod 'RxDataSources', '~> 4.0'  # https://github.com/RxSwiftCommunity/RxDataSources
    pod 'RxSwiftExt', '~> 5.0'  # https://github.com/RxSwiftCommunity/RxSwiftExt
    pod 'NSObject+Rx', '~> 5.0'  # https://github.com/RxSwiftCommunity/NSObject-Rx
    pod 'RxViewController', '~> 1.0'  # https://github.com/devxoul/RxViewController
    pod 'RxGesture', '~> 3.0'  # https://github.com/RxSwiftCommunity/RxGesture
    pod 'RxOptional', '~> 4.0'  # https://github.com/RxSwiftCommunity/RxOptional
    pod 'RxTheme', '~> 4.0'  # https://github.com/RxSwiftCommunity/RxTheme
    #pod 'RxAnimated', '~> 0.4'  # https://github.com/RxSwiftCommunity/RxAnimated

    # JSON Mapping
    #pod 'ObjectMapper', :git => 'https://github.com/kajensen/ObjectMapper.git'  # https://github.com/Hearst-DD/ObjectMapper
    pod 'Moya-ObjectMapper/RxSwift', :git => 'https://github.com/khoren93/Moya-ObjectMapper.git', :branch => 'moya14'  # https://github.com/ivanbruel/Moya-ObjectMapper

    # Image
    pod 'Kingfisher', '~> 5.0'  # https://github.com/onevcat/Kingfisher

    # Date
    pod 'DateToolsSwift', '~> 4.0'  # https://github.com/MatthewYork/DateTools
    pod 'SwiftDate', '~> 6.0'  # https://github.com/malcommac/SwiftDate

    # Tools
    pod 'R.swift', '~> 5.0'  # https://github.com/mac-cain13/R.swift
    pod 'SwiftLint', '0.37.0'  # https://github.com/realm/SwiftLint

    # Keychain
    pod 'KeychainAccess', '~> 4.0'  # https://github.com/kishikawakatsumi/KeychainAccess

    # Fabric
    pod 'Fabric'
    pod 'Crashlytics'

    # UI
    pod 'NVActivityIndicatorView', '~> 4.0'  # https://github.com/ninjaprox/NVActivityIndicatorView
    pod 'ImageSlideshow/Kingfisher', '~> 1.8'  # https://github.com/zvonicek/ImageSlideshow
    pod 'DZNEmptyDataSet', '~> 1.0'  # https://github.com/dzenbot/DZNEmptyDataSet
    pod 'Hero', '~> 1.5.0'  # https://github.com/lkzhao/Hero
    pod 'Localize-Swift', '~> 3.0'  # https://github.com/marmelroy/Localize-Swift
    pod 'RAMAnimatedTabBarController', '~> 5.0'  # https://github.com/Ramotion/animated-tab-bar
    pod 'AcknowList', '~> 1.8'  # https://github.com/vtourraine/AcknowList
    pod 'KafkaRefresh', '~> 1.0'  # https://github.com/OpenFeyn/KafkaRefresh
    pod 'WhatsNewKit', '~> 1.0'  # https://github.com/SvenTiigi/WhatsNewKit
    pod 'Highlightr', '~> 2.0'  # https://github.com/raspu/Highlightr
    pod 'DropDown', '~> 2.0'  # https://github.com/AssistoLab/DropDown
    pod 'Toast-Swift', '~> 5.0'  # https://github.com/scalessec/Toast-Swift
    pod 'HMSegmentedControl', '~> 1.0'  # https://github.com/HeshamMegid/HMSegmentedControl
    pod 'FloatingPanel', '~> 1.0'  # https://github.com/SCENEE/FloatingPanel
    pod 'MessageKit', '~> 3.0'  # https://github.com/MessageKit/MessageKit
    pod 'MultiProgressView', '~> 1.0'  # https://github.com/mac-gallagher/MultiProgressView

    # Keyboard
    pod 'IQKeyboardManagerSwift', '~> 6.0'  # https://github.com/hackiftekhar/IQKeyboardManager

    # Auto Layout
    pod 'SnapKit', '~> 5.0'  # https://github.com/SnapKit/SnapKit

    # Code Quality
    pod 'FLEX', :git => 'https://github.com/khoren93/FLEX.git', :branch => 'remove_private_api'  # https://github.com/Flipboard/FLEX
    pod 'SwifterSwift', '~> 5.0'  # https://github.com/SwifterSwift/SwifterSwift
    pod 'BonMot', '~> 5.0'  # https://github.com/Rightpoint/BonMot

    # Logging
    pod 'CocoaLumberjack/Swift', '~> 3.0'  # https://github.com/CocoaLumberjack/CocoaLumberjack

    # Analytics
    # https://github.com/devxoul/Umbrella
    pod 'Umbrella/Mixpanel', '~> 0.8'
    pod 'Umbrella/Firebase'
    pod 'Mixpanel', '~> 3.0'  # https://github.com/mixpanel/mixpanel-iphone
    pod 'Firebase/Analytics'

    # Ads
    pod 'Firebase/AdMob'
    pod 'Google-Mobile-Ads-SDK', '7.52.0'
    
    target 'SwiftHubTests' do
        inherit! :search_paths
        # Pods for testing
        pod 'Quick', '~> 2.0'  # https://github.com/Quick/Quick
        pod 'Nimble', '~> 8.0'  # https://github.com/Quick/Nimble
        #pod 'RxNimble', '~> 4.0'  # https://github.com/RxSwiftCommunity/RxNimble
        pod 'RxAtomic', :modular_headers => true
        pod 'RxBlocking'  # https://github.com/ReactiveX/RxSwift
        pod 'Firebase'
    end
end

target 'SwiftHubUITests' do
    inherit! :search_paths
    # Pods for testing
end


post_install do |installer|
    # Cocoapods optimization, always clean project after pod updating
    Dir.glob(installer.sandbox.target_support_files_root + "Pods-*/*.sh").each do |script|
        flag_name = File.basename(script, ".sh") + "-Installation-Flag"
        folder = "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
        file = File.join(folder, flag_name)
        content = File.read(script)
        content.gsub!(/set -e/, "set -e\nKG_FILE=\"#{file}\"\nif [ -f \"$KG_FILE\" ]; then exit 0; fi\nmkdir -p \"#{folder}\"\ntouch \"$KG_FILE\"")
        File.write(script, content)
    end
    
    # Enable tracing resources
    installer.pods_project.targets.each do |target|
      if target.name == 'RxSwift'
        target.build_configurations.each do |config|
          if config.name == 'Debug'
            config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
          end
        end
      end
    end
end
