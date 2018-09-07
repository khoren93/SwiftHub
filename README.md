# SwiftHub iOS
Open source Github iOS client written in RxSwift and MVVM architecture.

## Screenshots

<img alt="01_search_repository_screen_light" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/01_search_repository_screen_light.png?raw=true" width="290">&nbsp;
<img alt="01_search_repository_screen_dark" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/01_search_repository_screen_dark.png?raw=true" width="290">&nbsp;
<img alt="01_search_repository_screen_dark" src="https://github.com/khoren93/SwiftHub/blob/master/screenshots/02_events_screen_dark.png?raw=true" width="290">&nbsp;

## Features
* Basic authentication
* Clean architecture using [RxSwift](https://github.com/ReactiveX/RxSwift) and MVVM
* Flow coordinators
* Light and Dark themes
* Programmatically UI using [SnapKit](https://github.com/SnapKit/SnapKit)

## Planned Features
* OAuth2 authentication
* Dependency injection using [Swinject](https://github.com/Swinject/Swinject)
* In-app language switching
* Add analytics events
* More screens
* Add tests

## Building and Running

You'll need a few things before we get started. Make sure you have Xcode installed from the App Store. Then run the following two commands to install Xcode's command line tools and `bundler`, if you don't have that yet.

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
* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [Clean Architecture with RxSwift](https://github.com/sergdort/CleanArchitectureRxSwift)
* [View Model in RxSwift](https://medium.com/@SergDort/viewmodel-in-rxswift-world-13d39faa2cf5)
* [Moya](https://github.com/Moya/Moya)

## License
MIT License. See [LICENSE](https://github.com/khoren93/SwiftHub/blob/master/LICENSE).
