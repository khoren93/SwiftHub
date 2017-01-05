# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'SwiftHub' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SwiftHub

  # Networking
  pod 'ReachabilitySwift', '~> 3'  # https://github.com/ashleymills/Reachability.swift

  # Tools
  pod 'R.swift', '~> 3.0'  # https://github.com/mac-cain13/R.swift

  # Analytics
  pod 'ARAnalytics', :subspecs => ["Mixpanel"]
  pod 'Fabric'
  pod 'Crashlytics'

  target 'SwiftHubTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SwiftHubUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

# Cocoapods optimization
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
