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

### Process-death restoration (Android)

The Beacon Android SDK keeps its configuration in a process-static singleton. If Android kills the app process while `BeaconActivity` is in the foreground and later restores it, `BeaconActivity.onCreate` runs before any Dart code can call `Beacon.Builder().build()`, and the activity crashes with *"Beacon not initialized"*.

To handle this, the plugin registers a `BeaconInitProvider` `ContentProvider` (Android instantiates ContentProviders at process start, before any activity). It reads a default beaconId from the host app's `AndroidManifest.xml` and pre-builds Beacon. The runtime `HelpScoutBeacon(...)` call from Dart still overrides this with whatever beaconId you pass, so the manifest value is only used as a fallback during the window before Flutter starts.

Declare the meta-data in your host app's `AndroidManifest.xml`:

```xml
<application>
    <meta-data
        android:name="com.helpscout.beacon.BeaconId"
        android:value="YOUR_BEACON_ID" />
</application>
```

If you omit the meta-data, the plugin still works for normal launches — only the rare process-death restoration path remains unprotected.
