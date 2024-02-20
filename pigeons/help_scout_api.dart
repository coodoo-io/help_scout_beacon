import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/help_scout_api.g.dart',
  dartTestOut: 'test/help_scout_api_test.g.dart',
  kotlinOut: 'android/src/main/kotlin/de/coodoo/help_scout_beacon/HelpScoutApi.g.kt',
  swiftOut: 'ios/Classes/HelpScoutApi.g.swift',
  copyrightHeader: 'pigeons/copyright.txt',
  dartPackageName: 'help_scout_beacon',
))
class Version {
  String? string;
}

@HostApi(dartHostTestHandler: 'TestHelpScoutApi')
abstract class HelpScoutApi {
  void initialize(String beaconId);
  void open();
  void logout();
  void clear();
}
