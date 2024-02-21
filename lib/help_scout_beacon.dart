
import 'package:help_scout_beacon/help_scout_beacon_api.g.dart';

class HelpScoutBeacon {
  static Future<void> identify({required HSBeaconUser beaconUser}) async {
    await HelpScoutBeaconApi().identify(beaconUser: beaconUser);
  }

  static Future<void> open({required HSBeaconSettings settings, HSBeaconRoute route = HSBeaconRoute.ask, String? parameter}) async {
    await HelpScoutBeaconApi().open(settings: settings, route: route, parameter: parameter);
  }

  static Future<void> logout() async {
    await HelpScoutBeaconApi().logout();
  }
}
