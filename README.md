<img src="https://github.com/khoren93/SwiftHub/blob/master/Sketch/app_logo.svg" alt="SwiftHub logo" height="80" >

Open source Github iOS client written in RxSwift and MVVM architecture.

## Screenshots

<img alt="01_search_repository_screen_light" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/01_search_repository_screen_light.png?raw=true" width="290">&nbsp;
<img alt="02_repository_details_screen_dark" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/02_repository_details_screen_dark.png?raw=true" width="290">&nbsp;
<img alt="03_settings_screen_dark" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/03_settings_screen_dark.png?raw=true" width="290">&nbsp;

## Features
- [x] Basic authentication
- [x] Clean architecture ([RxSwift](https://github.com/ReactiveX/RxSwift) and MVVM)
- [x] Flow coordinators
- [x] Networking ([Moya](https://github.com/Moya/Moya))
- [x] Custom transition animations ([Hero](https://github.com/HeroTransitions/Hero))
- [x] Color themes in Light and Dark modes ([RxTheme](https://github.com/RxSwiftCommunity/RxTheme))
- [x] Programmatically UI ([SnapKit](https://github.com/SnapKit/SnapKit))
- [x] In-app language switching ([Localize-Swift](https://github.com/marmelroy/Localize-Swift))
- [x] Support iPhone and iPad (Split View)
- [x] Mixpanel and Firebase analytics events ([Umbrella](https://github.com/devxoul/Umbrella))
- [x] Crash reporting ([Crashlytics](https://fabric.io/kits/ios/crashlytics))
- [x] Whats New ([WhatsNewKit](https://github.com/SvenTiigi/WhatsNewKit))
- [x] Logging ([CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack))
- [ ] App Store application
- [ ] OAuth2 authentication
- [ ] Dependency injection ([Swinject](https://github.com/Swinject/Swinject))
- [ ] Add tests

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

[fastlane](https://fastlane.tools) automates common development tasks - for example bumping version numbers, running tests on multiple configurations, or submitting to the App Store. You can list the available lanes (our project-specific scripts) using `bundle exec fastlane lanes`. You can list available actions (all actions available to be scripted via lanes) using `bundle exec fastlane actions`. The fastlane configuration and scripts are in the `fastlane` folder.

## Design
All icons used in the application are taken from the [Feather](https://github.com/feathericons/feather).
Thanks to them for the beautiful open source icons.

## References
* [Moya](https://github.com/Moya/Moya) - Network abstraction layer
* [JSONExport](https://github.com/Ahmed-Ali/JSONExport) - Export JSON objects as model classes
* [CleanArchitectureRxSwift](https://github.com/sergdort/CleanArchitectureRxSwift) - Clean architecture with RxSwift
* [View Model in RxSwift](https://medium.com/@SergDort/viewmodel-in-rxswift-world-13d39faa2cf5) - Good article

## License
MIT License. See [LICENSE](https://github.com/khoren93/SwiftHub/blob/master/LICENSE).
