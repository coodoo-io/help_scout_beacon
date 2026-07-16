import 'package:cross_file/cross_file.dart';

import 'package:help_scout_beacon/help_scout_beacon_api.g.dart';

// Picks the native (dart:io / Pigeon) impl by default, and the web (JS interop)
// impl when compiling for the web. The unused file is tree-shaken away, so the
// native file's `dart:io` never reaches a web build and vice versa.
import 'package:help_scout_beacon/src/beacon_platform_native.dart'
    if (dart.library.js_interop) 'package:help_scout_beacon/src/beacon_platform_web.dart'
    as impl;

/// Platform-agnostic surface that [HelpScoutBeacon] delegates to.
abstract class BeaconPlatform {
  factory BeaconPlatform() => impl.createBeaconPlatform();

  Future<void> setup(HSBeaconSettings settings);
  Future<void> identify(HSBeaconUser beaconUser);
  Future<void> open(HSBeaconSettings settings, HSBeaconRoute route, String? parameter);
  Future<void> clear();
  Future<void> prefillContactForm(String? subject, String? message, List<XFile>? attachments);
}
