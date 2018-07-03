# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'SwiftHub' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for SwiftHub

  # Networking
  pod 'Moya/RxSwift', '~> 11.0'  # https://github.com/Moya/Moya
  pod 'ReachabilitySwift', '~> 4' # https://github.com/ashleymills/Reachability.swift

  # Rx Extensions
  pod 'RxDataSources', '~> 3.0'  # https://github.com/RxSwiftCommunity/RxDataSources
  pod 'NSObject+Rx', '~> 4.0'  # https://github.com/RxSwiftCommunity/NSObject-Rx
  pod 'RxGesture', '~> 1.0'  # https://github.com/RxSwiftCommunity/RxGesture
  pod 'RxOptional', '~> 3.0'  # https://github.com/RxSwiftCommunity/RxOptional
  
  # JSON Mapping
  #pod 'ObjectMapper', '~> 3.0'  # https://github.com/Hearst-DD/ObjectMapper
  pod 'Moya-ObjectMapper/RxSwift', '~> 2.0'  # https://github.com/ivanbruel/Moya-ObjectMapper

  # Image
  pod 'Kingfisher', '~> 4.0'  # https://github.com/onevcat/Kingfisher

  # Date
  pod 'DateToolsSwift', '~> 4.0'  # https://github.com/MatthewYork/DateTools
  pod 'SwiftDate', '~> 4.0'  # https://github.com/malcommac/SwiftDate

  # Phone
  #pod 'PhoneNumberKit', '~> 2.1'  # https://github.com/marmelroy/PhoneNumberKit

  # Tools
  pod 'R.swift', '~> 4.0'  # https://github.com/mac-cain13/R.swift
  pod 'SwiftLint', '0.26.0'  # https://github.com/realm/SwiftLint

  # Keychain
  pod 'KeychainAccess', '~> 3.0'  # https://github.com/kishikawakatsumi/KeychainAccess

  # Fabric
  pod 'Fabric'
  pod 'Crashlytics'

  # UI
  pod 'NVActivityIndicatorView', '~> 4.0'  # https://github.com/ninjaprox/NVActivityIndicatorView
  pod 'ImageSlideshow/Kingfisher', '~> 1.0'  # https://github.com/zvonicek/ImageSlideshow
  pod 'DZNEmptyDataSet', '~> 1.0'  # https://github.com/dzenbot/DZNEmptyDataSet
  pod 'Hero', '~> 1.0'  # https://github.com/lkzhao/Hero
  pod 'Localize-Swift', '~> 2.0'  # https://github.com/marmelroy/Localize-Swift

  # Keyboard
  pod 'IQKeyboardManagerSwift', '~> 6.0'  # https://github.com/hackiftekhar/IQKeyboardManager

  # Color
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'  # https://github.com/ViccAlexander/Chameleon

  # Auto Layout
  pod 'SnapKit', '~> 4.0'  # https://github.com/SnapKit/SnapKit

  # Code Quality
  pod 'FLEX', '~> 2.0'  # https://github.com/Flipboard/FLEX
  pod 'SwifterSwift', '~> 4.0'  # https://github.com/SwifterSwift/SwifterSwift

  # Logging
  pod 'CocoaLumberjack/Swift', '~> 3.0'  # https://github.com/CocoaLumberjack/CocoaLumberjack

  # Analytics
  pod 'Umbrella/Mixpanel'
  #pod 'Mixpanel-swift'  # https://github.com/mixpanel/mixpanel-swift

  target 'SwiftHubTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SwiftHubUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

# Cocoapods optimization, always clean project after pod updating
post_install do |installer|
  Dir.glob(installer.sandbox.target_support_files_root + "Pods-*/*.sh").each do |script|
    flag_name = File.basename(script, ".sh") + "-Installation-Flag"
    folder = "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
    file = File.join(folder, flag_name)
    content = File.read(script)
    content.gsub!(/set -e/, "set -e\nKG_FILE=\"#{file}\"\nif [ -f \"$KG_FILE\" ]; then exit 0; fi\nmkdir -p \"#{folder}\"\ntouch \"$KG_FILE\"")
    File.write(script, content)
  end
end
