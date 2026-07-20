# Changelog

## [0.2.0]

**All platforms**
- **FIX:** `HelpScoutBeacon.logout()` no longer throws on web when the beacon was never opened. The JS loader is now injected by every method, not just `setup`/`open`, so calling `logout` (or `identify`/`prefillContactForm`) first no longer hits an undefined `window.Beacon`.
- **FIX:** `prefillContactForm` resets the contact form first. Both native SDKs ignore a prefill while a draft message exists, so a stale draft silently discarded the prefilled values.
- **BREAKING:** `HSBeaconUser.attributes` is now `Map<String, String>?` instead of an untyped `Map?`, matching what both native SDKs accept. Non-string values were being stringified implicitly; convert them at the call site.
- `setup` runs once per configuration on iOS/Android too. Constructing a `HelpScoutBeacon` per open previously re-ran native setup every time, which rebuilt the Beacon from scratch on Android. Web already behaved this way.
- Add `HelpScoutBeacon.ready`, which completes when setup finishes. Every method awaits it internally, so a failing setup now surfaces on the call you made instead of as an unhandled async error.
- Prefill data applies to the next contact form only; previously it persisted for the process lifetime and leaked into later forms.
- Web: user attributes that collide with a built-in `identify` field (`email`, `name`, …) are dropped instead of overwriting it, and `open(route: article)` without an id falls back to the docs list rather than reopening the last screen.

**iOS**
- **FIX:** `HSBeaconSettings` overrides are applied again. `docsEnabled`, `messagingEnabled`, `chatEnabled` and `enablePreviousMessages` were silently dropped — a local variable shadowed the parameter, so each override assigned to itself and only `beaconId` and `focusMode` ever reached the SDK. Broken since `0.0.1-dev.2` (2024-02-24), when the overrides were added.
- **BREAKING:** the plugin builds in Swift 6 language mode and requires Xcode 26 (Swift 6.2 toolchain). Apps uploaded to App Store Connect must be built with Xcode 26 since April 28, 2026, so this only affects builds that are not being submitted.
- Pre-fill data is now guarded by a lock, fixing a data race between the platform channel writing it and the SDK reading it on the main thread.
- CocoaPods and Swift Package Manager now build the same sources — the podspec points at the SPM tree, replacing the duplicated `ios/Classes` copy that could drift out of sync.

**Android**
- Pin Kotlin's `jvmTarget` to 17 to match `compileOptions`, fixing a JVM-target mismatch build failure on Gradle 9 and recent JDKs.

**Docs**
- `HSBeaconSettings.debugLogging` is documented as Android only: neither the iOS SDK nor the JS Beacon exposes a logging switch.
- `HSBeaconSettings.beaconTitle` is documented as having no effect on any platform — the title comes from the Beacon Builder config, and the iOS SDK deprecated its equivalent property for the same reason.

**Tooling**
- Drop Pigeon's deprecated `dartTestOut`/`dartHostTestHandler` options and the generated test API they produced, so `flutter analyze` is clean again. Regenerate the platform APIs with Pigeon `27.1.2` (no API changes).
- Example: update to Gradle `9.6.1`, AGP `9.3.0` and Kotlin `2.4.10`.

## [0.1.0]

**Web**
- Web support: the plugin now works on web via the Help Scout JS Beacon SDK (`dart:js_interop`), alongside iOS/Android, through a single API. The Beacon loader is injected automatically on `setup()`, and `init` runs once per beaconId (re-initing an already-initialized web Beacon otherwise logs "Beacon has already been initialized").
- Add `HelpScoutBeacon.logout()` — a static, context-free logout (maps to `Beacon('logout')` on web, native user-clear on iOS/Android).
- **BREAKING:** `prefillContactForm` now takes `List<XFile>?` (from `package:cross_file`) instead of `List<File>?`, so the public API is web-safe. Pass `XFile(file.path)` instead of a `dart:io` `File`. Attachments remain iOS/Android-only — the web Beacon `prefill` ignores them.
- **BREAKING:** minimum Dart SDK raised to `3.4.0` (required for `dart:js_interop`).

**iOS**
- Add Swift Package Manager support.
- Bump `beacon-ios-sdk` SPM constraint from `4.0.0` to `4.1.0` — picks up upstream fixes for an `NSSecureCoding` keychain-decoding failure on launch and email-validation alignment with the Beacon web validator ([release notes](https://github.com/helpscout/beacon-ios-sdk/releases/tag/4.1.0)).

**Android**
- Update Beacon dependency to `beacon:7.0.2`.
- BeaconInitProvider pre-builds Beacon at process start from the host app's `com.helpscout.beacon.BeaconId` manifest meta-data, preventing `BeaconActivity` crashing with "Beacon not initialized" after process-death restoration.
- BeaconInitProvider `android:initOrder=-100` so it runs after the SDK's own `com.helpscout.beacon.BeaconInitProvider` (which sets up `BeaconCoordinator`); the build call is wrapped in try/catch for SDK-internals safety.

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
