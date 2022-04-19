fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios setup

```sh
[bundle exec] fastlane ios setup
```

Install all libraries

### ios update

```sh
[bundle exec] fastlane ios update
```

Update all tools and pods

### ios test

```sh
[bundle exec] fastlane ios test
```

Runs all the tests

### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```

Generate new localized screenshots

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Submit a new beta build to apple TestFlight

### ios release

```sh
[bundle exec] fastlane ios release
```

Deploy a new version to the App Store

### ios increment_build

```sh
[bundle exec] fastlane ios increment_build
```



### ios increment_version_patch

```sh
[bundle exec] fastlane ios increment_version_patch
```



### ios increment_version_minor

```sh
[bundle exec] fastlane ios increment_version_minor
```



### ios increment_version_major

```sh
[bundle exec] fastlane ios increment_version_major
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
