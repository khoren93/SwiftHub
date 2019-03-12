fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios setup
```
fastlane ios setup
```
Install all libraries
### ios update
```
fastlane ios update
```
Update all tools and pods
### ios test
```
fastlane ios test
```
Runs all the tests
### ios screenshots
```
fastlane ios screenshots
```
Generate new localized screenshots
### ios beta
```
fastlane ios beta
```
Submit a new beta build to apple TestFlight
### ios release
```
fastlane ios release
```
Deploy a new version to the App Store
### ios increment_build
```
fastlane ios increment_build
```

### ios increment_version_patch
```
fastlane ios increment_version_patch
```

### ios increment_version_minor
```
fastlane ios increment_version_minor
```

### ios increment_version_major
```
fastlane ios increment_version_major
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
