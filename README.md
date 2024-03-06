# Help Scout Beacon SDK for Flutter

Streamline customer communications in your app with the Help Scout Beacon SDK for Flutter.

## Requirements

The beacon Android SDK needs the follow:

* `minSdkVersion`: **21**
* `compileSdkVersion`:**34**
* Java 11 language feature support (compile with Java 17 as of version 5.0.0)
* Proguard Rules for Flutter release mode builds needed

Add this to your apps `android/app/build.gradle`:

```groovy
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig signingConfigs.debug
            // Beacon SDK needs Proguard
            shrinkResources false
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
```

## Usage

### Quick start
Configure the beacon with your `Beacon ID` and launch the beacon UI by calling `open`.

```dart
final settings = HSBeaconSettings(beaconId: 'YOUR_BEACON_ID');
HelpScoutBeacon.open(settings: settings);
```

### Identify User

Optionally you can prefill the beacon with user meta data:

```dart
HelpScoutBeacon.open(settings: HSBeaconSettings(beaconId: 'YOUR_BEACON_ID'));

final user = HSBeaconUser(email: "john.doe@example.com", name: "John Doe");
HelpScoutBeacon.identify(beaconUser: user);

```

### Navigate

Open a desired page in the Help Scout beacon UI:

```dart
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.ask));
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.chat));
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.docs));
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.docs, parameter: 'search term'));
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.contactForm));
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.previousMessages));
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.article, paramter: 'article id'));
```

### Cleanup / Logout

Once done you can remove all data:

```dart
HelpScoutBeacon.clear()
```
