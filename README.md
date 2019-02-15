<p align="center">
  <img src="https://github.com/khoren93/SwiftHub/blob/master/Sketch/app_logo.svg" alt="SwiftHub logo" height="80" >
</p>

<p align="center">
  Open source Github iOS client written in RxSwift and MVVM architecture.
</p>

<p align="center">
  <a href="https://itunes.apple.com/app/swifthub-git-client/id1448628710">
    <img alt="Download on the App Store" title="App Store" src="http://i.imgur.com/0n2zqHD.png" width="140">
  </a>
</p>

## Screenshots

<img alt="01_search_repository_screen_light" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/01_search_repository_screen.png?raw=true" width="290">&nbsp;
<img alt="02_repository_details_screen_dark" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/02_repository_details_screen.png?raw=true" width="290">&nbsp;
<img alt="03_settings_screen_dark" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/03_settings_screen.png?raw=true" width="290">&nbsp;

## App Features
- [x] Basic and OAuth2 authentication
- [x] View trending repositories and users ([github-trending-api](https://github.com/huchenme/github-trending-api))
- [x] Advanced searching and sorting repositories and users, filter by language
- [x] View repository and user details, events, issues, commits, pull requests, contributors, etc...
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
- [x] Networking REST API v3 ([Moya](https://github.com/Moya/Moya))
- [x] Custom transition animations ([Hero](https://github.com/HeroTransitions/Hero))
- [x] Programmatically UI ([SnapKit](https://github.com/SnapKit/SnapKit))
- [x] Mixpanel and Firebase analytics events ([Umbrella](https://github.com/devxoul/Umbrella))
- [x] Crash reporting ([Crashlytics](https://fabric.io/kits/ios/crashlytics))
- [x] Logging ([CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack))
- [x] Google ads implementation, can be enabled/disabled from settings ([Firebase AdMob](https://firebase.google.com/docs/admob/ios/quick-start))
- [ ] Migrating to GraphQL API v4 ([Apollo](https://github.com/apollographql/apollo-ios))
- [ ] Dependency injection ([Swinject](https://github.com/Swinject/Swinject))
- [ ] Add tests

## Tools
- [x] [bundler](https://bundler.io) - Bundler provides a consistent environment for Ruby projects by tracking and installing the exact gems and versions that are needed.
- [x] [Fastlane](https://github.com/fastlane/fastlane) - The easiest way to automate building and releasing your iOS and Android apps, generating localized screenshots
- [x] [SwiftLint](https://github.com/realm/SwiftLint) - A tool to enforce Swift style and conventions
- [x] [Jazzy](https://github.com/realm/jazzy) - Soulful docs for Swift & Objective-C
- [x] [JSONExport](https://github.com/Ahmed-Ali/JSONExport) - JSONExport is a desktop application which enables you to export JSON objects as model classes
- [x] [R.swift](https://github.com/mac-cain13/R.swift) - Get strong typed, autocompleted resources like images, fonts and segues in Swift projects
- [x] [Flex](https://github.com/Flipboard/FLEX) - An in-app debugging and exploration tool for iOS
- [x] [Postman](https://www.getpostman.com) - Postman Tools Support Every Stage of the API Lifecycle
- [x] [Sketch](https://www.sketchapp.com) - A digital design app (paid)
- [ ] [iThoughtsX](https://www.toketaware.com) - A mind mapping app for Windows, Mac, iPad and iPhone (paid)

## Building and Running

You'll need a few things before we get started. Make sure you have Xcode installed from the App Store. Then run the following two commands to install Xcode's command line tools and [`bundler`](https://bundler.io), if you don't have that yet.

```sh
[sudo] gem install bundler
xcode-select --install
```

The following commands will set up SwiftHub.

```sh
cd SwiftHub
bundle install
bundle exec fastlane setup
```

Try `pod update` if you got some errors.
Alrighty! We're ready to go!

## Sponsors
[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YDRAP3F94999S&source=url)

## Debugging
[Flex](https://github.com/Flipboard/FLEX) debugging tool has been integrated in this application. To enable it, just swipe right anywhere in the application.
There are also included debugging [Hero](https://github.com/HeroTransitions/Hero) animations. To use it, swipe right with two fingers. Repeat this to disable.

## Fastlane

[Fastlane](https://fastlane.tools) automates common development tasks - for example bumping version numbers, running tests on multiple configurations, or submitting to the App Store. You can list the available lanes (our project-specific scripts) using `bundle exec fastlane lanes`. You can list available actions (all actions available to be scripted via lanes) using `bundle exec fastlane actions`. The fastlane configuration and scripts are in the `fastlane` folder.

## Design
All icons used in the application are taken from the [Feather](https://github.com/feathericons/feather).
Thanks to them for the beautiful open source icons.

## References
* [CleanArchitectureRxSwift](https://github.com/sergdort/CleanArchitectureRxSwift) - Clean architecture with RxSwift
* [View Model in RxSwift](https://medium.com/@SergDort/viewmodel-in-rxswift-world-13d39faa2cf5) - Good article

## License
MIT License. See [LICENSE](https://github.com/khoren93/SwiftHub/blob/master/LICENSE).
