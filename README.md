# Help Scout Beacon SDK for Flutter

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
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.ask));
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.chat));
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.docs));
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.docs, parameter: 'search term'));
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.contactForm));
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.previousMessages));
HelpScoutBeacon.open(settings: settings, route: HSBeaconRoute.article, paramter: 'article id'));
```

### Cleanup / Logout

Once done you can remove all data by logging out:

```dart
HelpScoutBeacon.clear()
```
