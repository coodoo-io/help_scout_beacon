import 'package:help_scout_beacon/help_scout_beacon_api.g.dart';
import 'dart:io';

/// Flutter plugin to talk to the Help Scout iOS/Android Beacon SDK
class HelpScoutBeacon {
  HelpScoutBeacon(this.settings) : api = HelpScoutBeaconApi() {
    _setup();
  }

  final HSBeaconSettings settings;
  final HelpScoutBeaconApi api;

  /// Initialize the beacon with a beaconId and optional settings (only used in Android)
  Future<void> _setup() async {
    await api.setup(settings: settings);
  }

  /// Signs in with a Beacon user. This gives Beacon access to the user’s name, email address, and signature.
  Future<void> identify({required HSBeaconUser beaconUser}) async {
    await api.identify(beaconUser: beaconUser);
  }

  /// Opens the Beacon SDK from a specific view controller. The Beacon view controller will be presented as a modal.
  Future<void> open({
    HSBeaconRoute route = HSBeaconRoute.ask,
    String? parameter,
  }) async {
    await api.open(settings: settings, route: route, parameter: parameter);
  }

  /// Logs the current Beacon user out and clears out their information from local storage.
  Future<void> clear() async {
    await api.clear();
  }

  Future<void> prefillContactForm({
    String? subject,
    String? message,
    List<File>? attachments,
  }) async {
    final attachmentUris = attachments?.map((attachment) {
      if (Platform.isIOS) {
        return attachment.path;
      } else {
        return attachment.uri.toString();
      }
    }).toList();

    await api.prefillContactForm(subject, message, attachmentUris);
  }
}
