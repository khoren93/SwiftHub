# Uncomment the next line to define a global platform for your project
platform :ios, '17.0'

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
 
    # Image
    pod 'Kingfisher', '~> 8.0'  # https://github.com/onevcat/Kingfisher

    # Tools
    pod 'SwiftLint', '0.65.1'  # https://github.com/realm/SwiftLint

    # Keychain
    pod 'KeychainAccess', '~> 4.0'  # https://github.com/kishikawakatsumi/KeychainAccess

    # UI
    pod 'SVProgressHUD', '~> 2.0'  # https://github.com/SVProgressHUD/SVProgressHUD
    pod 'ImageSlideshow', :git => 'https://github.com/khoren93/ImageSlideshow.git', :branch => 'master'   # https://github.com/zvonicek/ImageSlideshow (KingfisherSource lives in SlideImageView.swift)
    pod 'AcknowList', '~> 3.0'  # https://github.com/vtourraine/AcknowList
    pod 'Highlightr', '~> 2.0'  # https://github.com/raspu/Highlightr
    pod 'Toast-Swift', '~> 5.0'  # https://github.com/scalessec/Toast-Swift
    pod 'FloatingPanel', '~> 3.0'  # https://github.com/SCENEE/FloatingPanel
    pod 'MessageKit', '~> 3.0'  # https://github.com/MessageKit/MessageKit
    
    # Keyboard
    pod 'IQKeyboardManagerSwift', '~> 8.0'  # https://github.com/hackiftekhar/IQKeyboardManager

    # Auto Layout
    pod 'SnapKit', '~> 5.0'  # https://github.com/SnapKit/SnapKit

    # Code Quality
    pod 'FLEX', '~> 5.0', :configurations => ['Debug']  # https://github.com/Flipboard/FLEX
    pod 'SwifterSwift', '~> 8.0'  # https://github.com/SwifterSwift/SwifterSwift

    # Logging
    pod 'CocoaLumberjack/Swift', '~> 3.0'  # https://github.com/CocoaLumberjack/CocoaLumberjack

    # Firebase https://github.com/firebase/firebase-ios-sdk
    pod 'FirebaseAnalytics', '~> 12.0'
    pod 'FirebaseCrashlytics', '~> 12.0'
    
    target 'SwiftHubTests' do
        inherit! :search_paths
        # Pods for testing
        pod 'Quick', '~> 7.0'  # https://github.com/Quick/Quick
        pod 'Nimble', '~> 14.0'  # https://github.com/Quick/Nimble
        pod 'RxBlocking'  # https://github.com/ReactiveX/RxSwift
    end
end

target 'SwiftHubUITests' do
    inherit! :search_paths
    # Pods for testing
end


post_install do |installer|
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
