# Help Scout Beacon SDK for Flutter

## Requirements

## Getting started

### Open Beacon-UI

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

### Logout / Cleanup

Once done you can remove all data by logging out:

```dart
HelpScoutBeacon.logout()
```
