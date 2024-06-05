# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

use_frameworks!
inhibit_all_warnings!

target 'SwiftHub' do
    # Pods for SwiftHub
    
    # Networking
    pod 'Moya/RxSwift', '~> 15.0'  # https://github.com/Moya/Moya
    pod 'Apollo', '0.53.0'  # https://github.com/apollographql/apollo-ios

    # Rx Extensions
    pod 'RxDataSources', '~> 5.0'  # https://github.com/RxSwiftCommunity/RxDataSources
    pod 'RxSwiftExt', '~> 6.0'  # https://github.com/RxSwiftCommunity/RxSwiftExt
    pod 'NSObject+Rx', '~> 5.0'  # https://github.com/RxSwiftCommunity/NSObject-Rx
    pod 'RxViewController', '~> 2.0'  # https://github.com/devxoul/RxViewController
    pod 'RxGesture', '~> 4.0'  # https://github.com/RxSwiftCommunity/RxGesture
    pod 'RxOptional', '~> 5.0'  # https://github.com/RxSwiftCommunity/RxOptional
    pod 'RxTheme', '~> 6.0'  # https://github.com/RxSwiftCommunity/RxTheme
 
    # JSON Mapping
    pod 'Moya-ObjectMapper/RxSwift', :git => 'https://github.com/p-rob/Moya-ObjectMapper.git', :branch => 'master'  # https://github.com/ivanbruel/Moya-ObjectMapper

    # Image
    pod 'Kingfisher', '~> 7.0'  # https://github.com/onevcat/Kingfisher

    # Date
    pod 'DateToolsSwift', '~> 5.0'  # https://github.com/MatthewYork/DateTools
    pod 'SwiftDate', '~> 7.0'  # https://github.com/malcommac/SwiftDate

    # Tools
    pod 'R.swift', '~> 7.0'  # https://github.com/mac-cain13/R.swift
    pod 'SwiftLint', '0.55.1'  # https://github.com/realm/SwiftLint

    # Keychain
    pod 'KeychainAccess', '~> 4.0'  # https://github.com/kishikawakatsumi/KeychainAccess

    # UI
    pod 'SVProgressHUD', '~> 2.0'  # https://github.com/SVProgressHUD/SVProgressHUD
    pod 'ImageSlideshow/Kingfisher', :git => 'https://github.com/khoren93/ImageSlideshow.git', :branch => 'master'   # https://github.com/zvonicek/ImageSlideshow
    pod 'DZNEmptyDataSet', '~> 1.0'  # https://github.com/dzenbot/DZNEmptyDataSet
    pod 'Hero', '~> 1.6'  # https://github.com/lkzhao/Hero
    pod 'Localize-Swift', '~> 3.0'  # https://github.com/marmelroy/Localize-Swift
    pod 'RAMAnimatedTabBarController', '~> 5.0'  # https://github.com/Ramotion/animated-tab-bar
    pod 'AcknowList', '~> 3.0'  # https://github.com/vtourraine/AcknowList
    pod 'KafkaRefresh', '~> 1.0'  # https://github.com/OpenFeyn/KafkaRefresh
    pod 'WhatsNewKit', '~> 1.0'  # https://github.com/SvenTiigi/WhatsNewKit
    pod 'Highlightr', '~> 2.0'  # https://github.com/raspu/Highlightr
    pod 'DropDown', '~> 2.0'  # https://github.com/AssistoLab/DropDown
    pod 'Toast-Swift', '~> 5.0'  # https://github.com/scalessec/Toast-Swift
    pod 'HMSegmentedControl', '~> 1.0'  # https://github.com/HeshamMegid/HMSegmentedControl
    pod 'FloatingPanel', '~> 2.0'  # https://github.com/SCENEE/FloatingPanel
    pod 'MessageKit', '~> 3.0'  # https://github.com/MessageKit/MessageKit
    pod 'MultiProgressView', '~> 1.0'  # https://github.com/mac-gallagher/MultiProgressView
    pod 'DGCharts', '~> 5.0'  # https://github.com/danielgindi/Charts
    
    # Keyboard
    pod 'IQKeyboardManagerSwift', '~> 7.0'  # https://github.com/hackiftekhar/IQKeyboardManager

    # Auto Layout
    pod 'SnapKit', '~> 5.0'  # https://github.com/SnapKit/SnapKit

    # Code Quality
    pod 'FLEX', '~> 5.0', :configurations => ['Debug']  # https://github.com/Flipboard/FLEX
    pod 'SwifterSwift', '~> 6.0'  # https://github.com/SwifterSwift/SwifterSwift
    pod 'BonMot', '~> 6.0'  # https://github.com/Rightpoint/BonMot

    # Logging
    pod 'CocoaLumberjack/Swift', '~> 3.0'  # https://github.com/CocoaLumberjack/CocoaLumberjack

    # Analytics
    pod 'Mixpanel-swift', '~> 4.0'  # https://github.com/mixpanel/mixpanel-iphone

    # Firebase https://github.com/firebase/firebase-ios-sdk
    pod 'FirebaseAnalytics', '~> 10.0'
    pod 'FirebaseCrashlytics', '~> 10.0'

    # Ads
    pod 'Google-Mobile-Ads-SDK', '~> 11.0'
    
    target 'SwiftHubTests' do
        inherit! :search_paths
        # Pods for testing
        pod 'Quick', '~> 7.0'  # https://github.com/Quick/Quick
        pod 'Nimble', '~> 13.0'  # https://github.com/Quick/Nimble
        pod 'RxAtomic', :modular_headers => true
        pod 'RxBlocking'  # https://github.com/ReactiveX/RxSwift
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
    
    # To hide deployment target warnings
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
end
