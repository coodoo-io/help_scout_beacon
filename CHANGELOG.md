# Changelog

## [0.0.11]
- Android: BeaconInitProvider — `android:initOrder=-100` so it runs after the SDK's own `com.helpscout.beacon.BeaconInitProvider` (which sets up `BeaconCoordinator`); wrap the build call in try/catch for SDK-internals safety.

## [0.0.10]
- Android: BeaconInitProvider pre-builds Beacon at process start from the host app's `com.helpscout.beacon.BeaconId` manifest meta-data, preventing `BeaconActivity` crashing with "Beacon not initialized" after process-death restoration.

## [0.0.9]
- Added Swift Package Manager support for iOS.
- Updated Android dependency to beacon:7.0.2.

## [0.0.8]
- Update Android dependency to beacon:7.0.0
- **BREAKING**: iOS minimum deployment target raised from 11.0 to 15.0

## [0.0.7]
- Adding option to prefill a contact form with a subject, message, and the attachments

## [0.0.6]
- Updating to the latest package
- fix attributes not submitted

## [0.0.5]

- Updating to the latest package
- Adding required pro-guard rules

## [0.0.4]

- Retracted version

## [0.0.3]

- Fixing Crashes in Android Plugin
- Updating Examples to Flutter 3.24.3

## [0.0.2]

- First successful use in a production app. Removing `-dev`.

## [0.0.1-dev.2]

- Adding Settings overrides
- Adding FocusMode


## [0.0.1-dev.1]

- Initial pre-release.
