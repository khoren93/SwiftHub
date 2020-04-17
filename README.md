<p align="center">
  <img src="https://github.com/khoren93/SwiftHub/blob/master/Sketch/app_logo.svg" alt="SwiftHub logo" height="80" >
</p>

<p align="center">
  GitHub iOS client in RxSwift and MVVM-C clean architecture.
</p>

<p align="center">
  KotlinHub - Android version is coming soon!
</p>

<p align="center">  
  SwiftUI and Combine coming soon!
</p>

<p align="center">
  <a href="https://itunes.apple.com/app/swifthub-git-client/id1448628710">
    <img alt="Download on the App Store" title="App Store" src="http://i.imgur.com/0n2zqHD.png" width="140">
  </a>
</p>

## Content
- [Screenshots](#screenshots)
- [Mind Mapping](#mind-mapping-full-version)
- [App Features](#app-features)
- [Technologies](#technologies)
- [Tools](#tools)
- [Building and Running](#building-and-running)
- [Documentation](#documentation)
- [Debugging](#debugging)
- [Fastlane](#fastlane)
- [Design](#design)
- [SwiftHub In](#swifthub-in)
- [References](#references)
- [See Also](#see-also)
- [License](#license)

## Screenshots

<img alt="04_trending_repository_screen" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/04_trending_repository_screen.png?raw=true" width="280">&nbsp;
<img alt="01_search_repository_screen" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/01_search_repository_screen.png?raw=true" width="280">&nbsp;
<img alt="02_repository_details_screen" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/02_repository_details_screen.png?raw=true" width="280">&nbsp;

<img alt="05_search_user_screen" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/05_search_user_screen.png?raw=true" width="280">&nbsp;
<img alt="06_user_details_screen" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/06_user_details_screen.png?raw=true" width="280">&nbsp;
<img alt="03_settings_screen" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/03_settings_screen.png?raw=true" width="280">&nbsp;

## Mind Mapping ([full version](https://github.com/khoren93/SwiftHub/blob/master/iThoughtsX/SwiftHub_full.pdf))
<p align="center">
  <a href="https://github.com/khoren93/SwiftHub/blob/master/iThoughtsX/SwiftHub_full.pdf">
    <img alt="SwiftHub mind note" src="https://github.com/khoren93/SwiftHub/blob/master/iThoughtsX/SwiftHub.png?raw=true" height="250">
  </a>
</p>

## App Features
- [x] Basic and OAuth2 authentication
- [x] View trending repositories and users ([github-trending-api](https://github.com/huchenme/github-trending-api))
- [x] Advanced searching and sorting repositories and users, filter by language
- [x] View repository and user details, events, issues, commits, pull requests, contributors, etc...
- [x] View issue and pull request messages ([MessageKit](https://github.com/MessageKit/MessageKit))
- [x] Tool for counting lines of code from github repositories ([codetabs](https://github.com/jolav/codetabs))
- [x] The missing star history graph of github repos ([stars-history](https://github.com/timqian/star-history))
- [x] Quickly browse the history of a file from any git repository ([git-history](https://github.com/pomber/git-history))
- [x] Tool for visualizing GitHub profiles ([profile-summary-for-github](https://github.com/tipsy/profile-summary-for-github))
- [x] Source file viewer and syntax highlighting ([Highlightr](https://github.com/raspu/Highlightr))
- [x] Color themes in light and dark modes ([RxTheme](https://github.com/RxSwiftCommunity/RxTheme))
- [x] In-app language switching (en, zh, ru, hy) ([Localize-Swift](https://github.com/marmelroy/Localize-Swift))
- [x] Whats New functionality ([WhatsNewKit](https://github.com/SvenTiigi/WhatsNewKit))
- [x] Invite friends functionality
- [x] Support iPhone and iPad (Split View)
- [ ] Clone repository directly to app ([SwiftGit2](https://github.com/SwiftGit2/SwiftGit2))

## Technologies
- [x] Clean architecture ([RxSwift](https://github.com/ReactiveX/RxSwift) and MVVM)
- [x] Flow coordinators ([Realm demo](https://github.com/realm/EventKit/blob/master/iOS/EventBlank2-iOS/Services/Navigator.swift))
- [x] REST API v3 (for unauthenticated or basic authentication) ([Moya](https://github.com/Moya/Moya), [ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper))
- [x] GraphQL API v4 (for OAuth2 authentication) ([Apollo](https://github.com/apollographql/apollo-ios))
- [x] Custom transition animations ([Hero](https://github.com/HeroTransitions/Hero))
- [x] Programmatically UI ([SnapKit](https://github.com/SnapKit/SnapKit))
- [x] Mixpanel and Firebase analytics events ([Umbrella](https://github.com/devxoul/Umbrella))
- [x] Crash reporting ([Crashlytics](https://fabric.io/kits/ios/crashlytics))
- [x] Logging ([CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack))
- [x] Google ads implementation, can be enabled/disabled from settings ([Firebase AdMob](https://firebase.google.com/docs/admob/ios/quick-start))
- [ ] Migrate to Apple's new [SwiftUI](https://developer.apple.com/xcode/swiftui/) and [Combine](https://developer.apple.com/documentation/combine)
- [ ] Dependency injection ([Swinject](https://github.com/Swinject/Swinject))
- [ ] Add tests

## Tools
- [x] [Brew](https://github.com/Homebrew/brew) - The missing package manager for macOS
- [x] [Bundler](https://github.com/bundler/bundler) - Manage your Ruby application's gem dependencies
- [x] [Fastlane](https://github.com/fastlane/fastlane) - The easiest way to automate building and releasing your iOS and Android apps
- [x] [SwiftLint](https://github.com/realm/SwiftLint) - A tool to enforce Swift style and conventions
- [x] [Jazzy](https://github.com/realm/jazzy) - Soulful docs for Swift & Objective-C
- [x] [JSONExport](https://github.com/Ahmed-Ali/JSONExport) - Is a desktop application which enables you to export JSON objects as model classes
- [x] [R.swift](https://github.com/mac-cain13/R.swift) - Get strong typed, autocompleted resources like images, fonts and segues in Swift projects
- [x] [Flex](https://github.com/Flipboard/FLEX) - An in-app debugging and exploration tool for iOS
- [x] [Sourcetree](https://www.sourcetreeapp.com) - A free Git client for Windows and Mac
- [x] [Postman](https://www.getpostman.com) - A powerful HTTP client for testing web services ([view](https://github.com/khoren93/SwiftHub/tree/master/Postman))
- [x] [Sketch](https://www.sketchapp.com) - A digital design app for Mac (paid) ([view](https://github.com/khoren93/SwiftHub/tree/master/Sketch))
- [x] [iThoughtsX](https://www.toketaware.com) - A mind mapping app for Windows, Mac, iPad and iPhone (paid) ([view](https://github.com/khoren93/SwiftHub/tree/master/iThoughtsX))

## Building and Running

You'll need a few things before we get started. 
Make sure you have Xcode installed from the App Store. 
Then run the following command to install Xcode's command line tools, if you don't have that yet
```sh
xcode-select --install
```

Install [`Bundler`](https://bundler.io) for managing Ruby gem dependencies
```sh
[sudo] gem install bundler
```

Install [Brew](https://github.com/Homebrew/brew) package manager for macOS
```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Install [`Node`](https://nodejs.org/en/) (required to install [Apollo](https://github.com/apollographql/apollo-ios))
```sh
brew install node
```

The following commands will set up SwiftHub
```sh
cd SwiftHub
bundle install
bundle exec fastlane setup
```

To update all tools and pods
```sh
bundle exec fastlane update
```

Alrighty! We're ready to go!

## Documentation
You can generate the API docs locally. Run `jazzy` from the root of this repository. This requires installation of [jazzy](https://github.com/realm/jazzy/). You will find the output in `docs/`. You can set options for your project’s documentation in a configuration file, [.jazzy.yaml](https://github.com/khoren93/SwiftHub/blob/master/.jazzy.yaml) by default.

## Debugging
[Flex](https://github.com/Flipboard/FLEX) debugging tool has been integrated in this application. To enable it, just swipe right anywhere in the application.
There are also included debugging [Hero](https://github.com/HeroTransitions/Hero) animations. To use it, swipe right with two fingers. Repeat this to disable.

## Fastlane

[Fastlane](https://fastlane.tools) automates common development tasks - for example bumping version numbers, running tests on multiple configurations, or submitting to the App Store. You can list the available lanes (our project-specific scripts) using `bundle exec fastlane lanes`. You can list available actions (all actions available to be scripted via lanes) using `bundle exec fastlane actions`. The fastlane configuration and scripts are in the `fastlane` folder.

## Design
All icons used in the application are taken from the [Feather](https://github.com/feathericons/feather).
Thanks to them for the beautiful open source icons.

## SwiftHub In
* [open-source-ios-apps](https://github.com/dkhamsing/open-source-ios-apps#github) - Collaborative List of Open-Source iOS Apps
* [fantastic-ios-architecture](https://github.com/onmyway133/fantastic-ios-architecture#repos-7) - Better ways to structure iOS apps
* [Moya](https://github.com/Moya/Moya/blob/master/docs/CommunityProjects.md#Applications) - Community Projects
* [MessageKit](https://github.com/MessageKit/MessageKit#apps-using-this-library) - Apps using this library
* [github-trending-api](https://github.com/huchenme/github-trending-api#projects-using-github-trending-api) - Projects using this library
* [awesome-rxswift](https://github.com/LeoMobileDeveloper/awesome-rxswift#open-source-apps) - Curated list of RxSwift library and learning material
* [Medium-Mybridge](https://medium.mybridge.co/swift-open-source-for-the-past-month-v-may-2019-c0f6a0d61e34) - Swift Open Source for the Past Month (v.May 2019)

## References
* [CleanArchitectureRxSwift](https://github.com/sergdort/CleanArchitectureRxSwift) - Clean architecture with RxSwift
* [View Model in RxSwift](https://medium.com/@SergDort/viewmodel-in-rxswift-world-13d39faa2cf5) - Good article

## See Also
* [GitHawk](https://github.com/GitHawkApp/GitHawk) - The best iOS app for GitHub
* [CodeHub](https://github.com/CodeHubApp/CodeHub) - An iOS application written using Xamarin
* [GitPoint](https://github.com/gitpoint/git-point) - GitHub in your pocket
* [DevHub](https://github.com/devhubapp/devhub) - TweetDeck for GitHub - Android, iOS, Web & Desktop
* [OpenHub](https://github.com/ThirtyDegreesRay/OpenHub) - An open source GitHub Android client app, faster and concise
* [Trailer](https://github.com/ptsochantaris/trailer) - Managing Pull Requests and Issues For GitHub & GitHub Enterprise
* [FastHub](https://github.com/k0shk0sh/FastHub) - FastHub the ultimate GitHub client for Android.

## License
MIT License. See [LICENSE](https://github.com/khoren93/SwiftHub/blob/master/LICENSE).
