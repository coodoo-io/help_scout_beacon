import 'package:cross_file/cross_file.dart';

import 'package:help_scout_beacon/help_scout_beacon_api.g.dart';
import 'package:help_scout_beacon/src/beacon_platform.dart';

export 'package:help_scout_beacon/help_scout_beacon_api.g.dart'
    show
        HSBeaconSettings,
        HSBeaconUser,
        HSBeaconRoute,
        HSBeaconFocusMode;

/// Flutter plugin to talk to the Help Scout Beacon SDK.
///
/// * iOS / Android use the native Beacon SDK (via Pigeon).
/// * Web uses the Help Scout Beacon JS SDK (via JS interop).
class HelpScoutBeacon {
  HelpScoutBeacon(this.settings) : _platform = BeaconPlatform() {
    _setup();
  }

  final HSBeaconSettings settings;
  final BeaconPlatform _platform;

  /// Initialize the beacon with a beaconId and optional settings.
  Future<void> _setup() async => _platform.setup(settings);

  /// Signs in with a Beacon user. This gives Beacon access to the user’s name,
  /// email address, and signature.
  Future<void> identify({required HSBeaconUser beaconUser}) async =>
      _platform.identify(beaconUser);

  /// Opens the Beacon UI at a specific [route].
  Future<void> open({
    HSBeaconRoute route = HSBeaconRoute.ask,
    String? parameter,
  }) async =>
      _platform.open(settings, route, parameter);

  /// Logs the current Beacon user out and clears their local information.
  Future<void> clear() async => _platform.clear();

  /// Logs the current Beacon user out without needing a configured instance.
  ///
  /// Handy on logout, where no [HSBeaconSettings] (and hence no beaconId) is
  /// available. On web this maps to `Beacon('logout')`, which needs no id;
  /// on iOS/Android it clears the native user.
  static Future<void> logout() async => BeaconPlatform().clear();

  /// Prefill the contact form with subject, message and attachments.
  ///
  /// NOTE: [attachments] are only applied on iOS/Android. The web Beacon
  /// `prefill` API supports form fields but not file attachments.
  Future<void> prefillContactForm({
    String? subject,
    String? message,
    List<XFile>? attachments,
  }) async =>
      _platform.prefillContactForm(subject, message, attachments);
}
