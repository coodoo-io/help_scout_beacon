import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/help_scout_beacon_api.g.dart',
    dartTestOut: 'test/help_scout_beacon_test.g.dart',
    kotlinOut:
        'android/src/main/kotlin/de/coodoo/help_scout_beacon/HelpScoutBeaconApi.g.kt',
    swiftOut: 'ios/Classes/HelpScoutBeaconApi.g.swift',
    copyrightHeader: 'pigeons/copyright.txt',
    dartPackageName: 'help_scout_beacon',
  ),
)

/// Beacon Settings overrides
/// * https://developer.helpscout.com/beacon-2/android-api/beacon/com.helpscout.beacon.model/-beacon-screens/index.html
/// * https://developer.helpscout.com/beacon-2/ios-api/Classes/HSBeaconSettings.html
class HSBeaconSettings {
  const HSBeaconSettings({
    required this.beaconId,
    this.debugLogging = false,
    this.beaconTitle,
    this.docsEnabled,
    this.messagingEnabled,
    this.chatEnabled,
    this.enablePreviousMessages = true,
    this.focusMode,
  });

  /// The Beacon ID to use.
  final String beaconId;

  /// Turn Logging on/off (should be disabled in production)
  final bool debugLogging;

  /// The title used in the main Beacon interface. This is Support by default.
  final String? beaconTitle;

  /// Disable the Docs integration manually if it’s enabled in the Beacon config.
  /// This will not enable Docs if it’s disabled in the config.
  final bool? docsEnabled;

  /// Disable the contact options manually if it’s enabled in the Beacon config.
  /// This will not enable the contact options if it’s disabled in the config.
  final bool? messagingEnabled;

  /// Disable the Chat integration manually if it’s enabled in the Beacon config.
  /// This will not enable Chat if it’s disabled in the config.
  final bool? chatEnabled;

  /// Disable previous messages manually if messaging is enabled in the Beacon config.
  final bool enablePreviousMessages;

  /// If your Beacon has Docs and Messaging (email or chat) enabled, this mode controls the user experience of the beacon
  final HSBeaconFocusMode? focusMode;
}

/// Beacon route/screen
/// * https://developer.helpscout.com/beacon-2/android-api/beacon/com.helpscout.beacon.model/-beacon-screens/index.html
enum HSBeaconRoute {
  /// Opens to the Home (Ask/Answers) screen (default value)
  ask,

  /// Chat screen
  chat,

  /// Open docs with optional search parameter (requires docs enabled and optionally a search param)
  docs,

  /// Article screen (requires an Article ID and docs enabled)
  article,

  /// Contact form (requires messaging enabled)
  contactForm,

  /// Previous Messages if any exist.
  previousMessages,
}

/// HSBeaconFocusMode represents various configuration modes of Beacon. Allowing you to customize the experience your users have, from getting in contact right away, to a more self service approach.
/// * More info is available AT https://docs.helpscout.com/article/1296-work-with-beacon-modes
enum HSBeaconFocusMode {
  /// An option to see both help articles and contact options side by side
  neutral,

  /// An option to see help articles first and contact options after interacting with content
  selfService,

  /// An option to see contact options first and help articles second
  askFirst,
}

/// Beacon user
/// * https://developer.helpscout.com/beacon-2/android-api/beacon/com.helpscout.beacon.model/-beacon-user/index.html
/// * https://developer.helpscout.com/beacon-2/ios-api/Classes/HSBeaconUser.html
class HSBeaconUser {
  const HSBeaconUser({
    required this.email,
    this.name,
    this.company,
    this.jobTitle,
    this.avatar,
    this.attributes,
  });

  /// The email address for the current user.
  final String email;

  /// The name of the current user.
  final String? name;

  /// The company of the current user. The max length of this value is 60 and will be truncated to fit.
  final String? company;

  /// The job title of the current user. The max length of this value is 60 and will be truncated to fit.
  final String? jobTitle;

  /// The URL to the avatar of the current user. The max length of this value is 200 and will not be set if the absoluteString exceeds that length.
  final String? avatar;

  /// The attributes for the current user. These are arbitrary key/value pairs that will be sent to Help Scout to help identify the current user. You may add up to 30 different attributes.
  final Map? attributes;
}

/// Help Scout Beacon API
@HostApi(dartHostTestHandler: 'TestHelpScoutBeaconApi')
abstract class HelpScoutBeaconApi {
  /// Initialize the beacon with a beaconId and optional settings
  void setup({required HSBeaconSettings settings});

  /// Signs in with a Beacon user. This gives Beacon access to the user’s name, email address, and signature.
  void identify({required HSBeaconUser beaconUser});

  /// Opens the Beacon SDK from a specific view controller. The Beacon view controller will be presented as a modal.
  void open({
    required HSBeaconSettings settings,
    HSBeaconRoute route = HSBeaconRoute.ask,
    String? parameter,
  });
  void prefillContactForm(
    String? subject,
    String? message,
    List<String>? attachments,
  );

  /// Logs the current Beacon user out and clears out their information from local storage.
  void clear();
}
