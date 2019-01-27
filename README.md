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

<img alt="01_search_repository_screen_light" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/01_search_repository_screen_light.png?raw=true" width="290">&nbsp;
<img alt="02_repository_details_screen_dark" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/02_repository_details_screen_dark.png?raw=true" width="290">&nbsp;
<img alt="03_settings_screen_dark" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/03_settings_screen_dark.png?raw=true" width="290">&nbsp;

## App Features
- [x] Basic authentication
- [x] View trendings ([github-trending-api](https://github.com/huchenme/github-trending-api))
- [x] Advanced searching and sorting repositories and users, filter by language
- [x] View repository and user details, events, issues, commits, pull requests, contributors, etc...
- [x] Source file viewer and syntax highlighting ([Highlightr](https://github.com/raspu/Highlightr))
- [x] Color themes in light and dark modes ([RxTheme](https://github.com/RxSwiftCommunity/RxTheme))
- [x] In-app language switching (en, zh, ru, hy) ([Localize-Swift](https://github.com/marmelroy/Localize-Swift))
- [x] Whats New functionality ([WhatsNewKit](https://github.com/SvenTiigi/WhatsNewKit))
- [x] Invite friends functionality
- [x] Support iPhone and iPad (Split View)
- [ ] OAuth2 authentication
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
- [ ] Dependency injection ([Swinject](https://github.com/Swinject/Swinject))
- [ ] Add tests (help is welcome)

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

## Debugging
[Flex](https://github.com/Flipboard/FLEX) debugging tool has been integrated in this application. To enable it, just swipe right anywhere in the application.
There are also included debugging [Hero](https://github.com/HeroTransitions/Hero) animations. To use it, swipe right with two fingers. Repeat this to disable.

## Fastlane

[Fastlane](https://fastlane.tools) automates common development tasks - for example bumping version numbers, running tests on multiple configurations, or submitting to the App Store. You can list the available lanes (our project-specific scripts) using `bundle exec fastlane lanes`. You can list available actions (all actions available to be scripted via lanes) using `bundle exec fastlane actions`. The fastlane configuration and scripts are in the `fastlane` folder.

## Design
All icons used in the application are taken from the [Feather](https://github.com/feathericons/feather).
Thanks to them for the beautiful open source icons.

## References
* [Moya](https://github.com/Moya/Moya) - Network abstraction layer
* [R.swift](https://github.com/mac-cain13/R.swift) - Get strong typed, autocompleted resources like images, fonts and segues in Swift projects
* [JSONExport](https://github.com/Ahmed-Ali/JSONExport) - Export JSON objects as model classes
* [CleanArchitectureRxSwift](https://github.com/sergdort/CleanArchitectureRxSwift) - Clean architecture with RxSwift
* [View Model in RxSwift](https://medium.com/@SergDort/viewmodel-in-rxswift-world-13d39faa2cf5) - Good article

## License
MIT License. See [LICENSE](https://github.com/khoren93/SwiftHub/blob/master/LICENSE).
