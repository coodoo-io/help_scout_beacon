import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Web plugin registrant.
///
/// This plugin dispatches to its web implementation via conditional imports
/// (see `beacon_platform.dart`), not through a MethodChannel, so there is
/// nothing to register here. The class exists only to satisfy the `web`
/// entry in pubspec.yaml's `flutter.plugin.platforms`.
class HelpScoutBeaconWeb {
  static void registerWith(Registrar registrar) {
    // Intentionally empty.
  }
}
