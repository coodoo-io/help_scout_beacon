import 'package:help_scout_beacon/help_scout_beacon_api.g.dart';

/// Flutter plugin to talk to the Help Scout iOS/Android Beacon SDK
class HelpScoutBeacon {
  /// Signs in with a Beacon user. This gives Beacon access to the user’s name, email address, and signature.
  Future<void> identify({required HSBeaconUser beaconUser}) async {
    await HelpScoutBeaconApi().identify(beaconUser: beaconUser);
  }

  /// Opens the Beacon SDK from a specific view controller. The Beacon view controller will be presented as a modal.
  Future<void> open({
    required HSBeaconSettings settings,
    HSBeaconRoute route = HSBeaconRoute.ask,
    String? parameter,
  }) async {
    await HelpScoutBeaconApi().open(settings: settings, route: route, parameter: parameter);
  }

  /// Logs the current Beacon user out and clears out their information from local storage.
  Future<void> logout() async {
    await HelpScoutBeaconApi().logout();
  }
}
