import 'dart:io';

import 'package:cross_file/cross_file.dart';

import 'package:help_scout_beacon/help_scout_beacon_api.g.dart';
import 'package:help_scout_beacon/src/beacon_platform.dart';

BeaconPlatform createBeaconPlatform() => BeaconPlatformNative();

/// iOS / Android implementation backed by the native Beacon SDK via Pigeon.
class BeaconPlatformNative implements BeaconPlatform {
  final HelpScoutBeaconApi _api = HelpScoutBeaconApi();

  @override
  Future<void> setup(HSBeaconSettings settings) => _api.setup(settings: settings);

  @override
  Future<void> identify(HSBeaconUser beaconUser) => _api.identify(beaconUser: beaconUser);

  @override
  Future<void> open(HSBeaconSettings settings, HSBeaconRoute route, String? parameter) =>
      _api.open(settings: settings, route: route, parameter: parameter);

  @override
  Future<void> clear() => _api.clear();

  @override
  Future<void> prefillContactForm(String? subject, String? message, List<XFile>? attachments) {
    // Preserve the original platform-specific path handling:
    // iOS expects a plain filesystem path, Android expects a file:// URI.
    final attachmentUris = attachments?.map((a) {
      return Platform.isIOS ? a.path : Uri.file(a.path).toString();
    }).toList();
    return _api.prefillContactForm(subject, message, attachmentUris);
  }
}
