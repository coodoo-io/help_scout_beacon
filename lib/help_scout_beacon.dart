import 'package:help_scout_beacon/help_scout_api.g.dart';

class HelpScoutBeacon {
  static final HelpScoutBeacon _singleton = HelpScoutBeacon._internal();
  final HelpScoutApi _helpScoutApi = HelpScoutApi();

  factory HelpScoutBeacon() {
    return _singleton;
  }
  HelpScoutBeacon._internal();


  Future<void> initialize({required String beaconId}) async {
    await _helpScoutApi.initialize(beaconId);
  }

  Future<void> open() async {
    await _helpScoutApi.open();
  }

  Future<void> logout() async {
    await _helpScoutApi.logout();
  }

  Future<void> clear() async {
    await _helpScoutApi.clear();
  }
}
