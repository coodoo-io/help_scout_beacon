# Help Scout Beacon SDK for Flutter

Streamline customer communications in your app with the Help Scout Beacon SDK for Flutter.


[See Demo](./example/lib/main.dart)
*Add your BeaconId in `main.dart`*

## Usage

### Quick start
Configure the beacon with your `Beacon ID` and launch the beacon UI by calling `open`.

```dart
final HelpScoutBeacon beacon = HelpScoutBeacon(HSBeaconSettings(beaconId: 'YOUR_BEACON_ID'));
beacon.open();
```

### Identify User

Optionally you can prefill the beacon with user meta data:

```dart
final settings = HSBeaconSettings(beaconId: 'YOUR_BEACON_ID', debugLogging: true);
final HelpScoutBeacon beacon = HelpScoutBeacon(settings);

final user = HSBeaconUser(email: "john.doe@example.com", name: "John Doe");
beacon.identify(beaconUser: user);
beacon.open();
```

### Navigate

Open a desired page in the Help Scout beacon UI:

```dart
beacon.open(route: HSBeaconRoute.ask);
beacon.open(route: HSBeaconRoute.chat);
beacon.open(route: HSBeaconRoute.contactForm);
beacon.open(route: HSBeaconRoute.previousMessages);
beacon.open(route: HSBeaconRoute.docs);
beacon.open(route: HSBeaconRoute.docs, parameter: 'search term');
beacon.open(route: HSBeaconRoute.article, paramter: 'article id');
```

Open a prefilled Contact Form page with a subject, message, and the attachments in the Help Scout beacon UI:

```dart
await beacon.prefillContactForm(
  subject: 'Help Scout',
  message: 'This is sample prefilled message',
  attachments: [file]);
beacon.open(route: HSBeaconRoute.contactForm);
```

### Cleanup / Logout

Once done you can remove all data:

```dart
beacon.clear()
```

### Release mode

The newest version on Android requires to setup pro-guard rules.
See example project [proguard-rules.pro](.example/android/app/proguard-rules.pro)
