# Help Scout Beacon SDK for Flutter

## Getting started

Configure the beacon with your `Beacon ID` and launch the beacon UI by calling `open`.

```dart
final settings = HSBeaconSettings(beaconId: 'YOUR_BEACON_ID');
HelpScoutBeacon.open(settings: settings);
```

### Identify User

Optionally you can prefill the beacon with user meta data:

```dart
final user = HSBeaconUser(email: "john.doe@example.com", name: "John Doe");
HelpScoutBeacon.identify(beaconUser: user);

HelpScoutBeacon.open(settings: HSBeaconSettings(beaconId: 'YOUR_BEACON_ID'));
```

### Navigate

Open a desired page in the Help Scout beacon UI:

```dart
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.ask)); // ASK
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.chat)); // CHAT
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.docs)); // DOCS
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.docs, parameter: 'search term')); // DOCS with search
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.contactForm)); // contact form
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.previousMessages)); // previous messages
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.article, paramter: 'article id')); // article
```

### Cleanup / Logout

Once done you can remove all data by logging out:

```dart
HelpScoutBeacon.clear()
```
