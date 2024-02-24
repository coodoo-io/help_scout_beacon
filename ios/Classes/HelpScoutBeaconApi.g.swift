// Autogenerated from Pigeon (v17.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details,
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)",
  ]
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

/// Beacon route/screen
/// * https://developer.helpscout.com/beacon-2/android-api/beacon/com.helpscout.beacon.model/-beacon-screens/index.html
enum HSBeaconRoute: Int {
  /// Opens to the Home (Ask/Answers) screen (default value)
  case ask = 0
  /// Chat screen
  case chat = 1
  /// Open docs with optional search parameter (requires docs enabled and optionally a search param)
  case docs = 2
  /// Article screen (requires an Article ID and docs enabled)
  case article = 3
  /// Contact form (requires messaging enabled)
  case contactForm = 4
  /// Previous Messages if any exist.
  case previousMessages = 5
}

/// HSBeaconFocusMode represents various configuration modes of Beacon. Allowing you to customize the experience your users have, from getting in contact right away, to a more self service approach.
/// * More info is available AT https://docs.helpscout.com/article/1296-work-with-beacon-modes
enum HSBeaconFocusMode: Int {
  /// An option to see both help articles and contact options side by side
  case neutral = 0
  /// An option to see help articles first and contact options after interacting with content
  case selfService = 1
  /// An option to see contact options first and help articles second
  case askFirst = 2
}

/// Beacon Settings overrides
/// * https://developer.helpscout.com/beacon-2/android-api/beacon/com.helpscout.beacon.model/-beacon-screens/index.html
/// * https://developer.helpscout.com/beacon-2/ios-api/Classes/HSBeaconSettings.html
///
/// Generated class from Pigeon that represents data sent in messages.
struct HSBeaconSettings {
  /// The Beacon ID to use.
  var beaconId: String
  /// The title used in the main Beacon interface. This is Support by default.
  var beaconTitle: String? = nil
  /// Disable the Docs integration manually if it’s enabled in the Beacon config.
  /// This will not enable Docs if it’s disabled in the config.
  var docsEnabled: Bool? = nil
  /// Disable the contact options manually if it’s enabled in the Beacon config.
  /// This will not enable the contact options if it’s disabled in the config.
  var messagingEnabled: Bool? = nil
  /// Disable the Chat integration manually if it’s enabled in the Beacon config.
  /// This will not enable Chat if it’s disabled in the config.
  var chatEnabled: Bool? = nil
  /// Disable previous messages manually if messaging is enabled in the Beacon config.
  var enablePreviousMessages: Bool
  /// If your Beacon has Docs and Messaging (email or chat) enabled, this mode controls the user experience of the beacon
  var focusMode: HSBeaconFocusMode? = nil

  static func fromList(_ list: [Any?]) -> HSBeaconSettings? {
    let beaconId = list[0] as! String
    let beaconTitle: String? = nilOrValue(list[1])
    let docsEnabled: Bool? = nilOrValue(list[2])
    let messagingEnabled: Bool? = nilOrValue(list[3])
    let chatEnabled: Bool? = nilOrValue(list[4])
    let enablePreviousMessages = list[5] as! Bool
    var focusMode: HSBeaconFocusMode? = nil
    let focusModeEnumVal: Int? = nilOrValue(list[6])
    if let focusModeRawValue = focusModeEnumVal {
      focusMode = HSBeaconFocusMode(rawValue: focusModeRawValue)!
    }

    return HSBeaconSettings(
      beaconId: beaconId,
      beaconTitle: beaconTitle,
      docsEnabled: docsEnabled,
      messagingEnabled: messagingEnabled,
      chatEnabled: chatEnabled,
      enablePreviousMessages: enablePreviousMessages,
      focusMode: focusMode
    )
  }
  func toList() -> [Any?] {
    return [
      beaconId,
      beaconTitle,
      docsEnabled,
      messagingEnabled,
      chatEnabled,
      enablePreviousMessages,
      focusMode?.rawValue,
    ]
  }
}

/// Beacon user
/// * https://developer.helpscout.com/beacon-2/android-api/beacon/com.helpscout.beacon.model/-beacon-user/index.html
/// * https://developer.helpscout.com/beacon-2/ios-api/Classes/HSBeaconUser.html
///
/// Generated class from Pigeon that represents data sent in messages.
struct HSBeaconUser {
  /// The email address for the current user.
  var email: String
  /// The name of the current user.
  var name: String? = nil
  /// The company of the current user. The max length of this value is 60 and will be truncated to fit.
  var company: String? = nil
  /// The job title of the current user. The max length of this value is 60 and will be truncated to fit.
  var jobTitle: String? = nil
  /// The URL to the avatar of the current user. The max length of this value is 200 and will not be set if the absoluteString exceeds that length.
  var avatar: String? = nil
  /// The attributes for the current user. These are arbitrary key/value pairs that will be sent to Help Scout to help identify the current user. You may add up to 30 different attributes.
  var attributes: [AnyHashable: Any?]? = nil

  static func fromList(_ list: [Any?]) -> HSBeaconUser? {
    let email = list[0] as! String
    let name: String? = nilOrValue(list[1])
    let company: String? = nilOrValue(list[2])
    let jobTitle: String? = nilOrValue(list[3])
    let avatar: String? = nilOrValue(list[4])
    let attributes: [AnyHashable: Any?]? = nilOrValue(list[5])

    return HSBeaconUser(
      email: email,
      name: name,
      company: company,
      jobTitle: jobTitle,
      avatar: avatar,
      attributes: attributes
    )
  }
  func toList() -> [Any?] {
    return [
      email,
      name,
      company,
      jobTitle,
      avatar,
      attributes,
    ]
  }
}
private class HelpScoutBeaconApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
    case 128:
      return HSBeaconSettings.fromList(self.readValue() as! [Any?])
    case 129:
      return HSBeaconUser.fromList(self.readValue() as! [Any?])
    default:
      return super.readValue(ofType: type)
    }
  }
}

private class HelpScoutBeaconApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? HSBeaconSettings {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else if let value = value as? HSBeaconUser {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class HelpScoutBeaconApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return HelpScoutBeaconApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return HelpScoutBeaconApiCodecWriter(data: data)
  }
}

class HelpScoutBeaconApiCodec: FlutterStandardMessageCodec {
  static let shared = HelpScoutBeaconApiCodec(readerWriter: HelpScoutBeaconApiCodecReaderWriter())
}

/// Help Scout Beacon API
///
/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol HelpScoutBeaconApi {
  /// Signs in with a Beacon user. This gives Beacon access to the user’s name, email address, and signature.
  func identify(beaconUser: HSBeaconUser) throws
  /// Opens the Beacon SDK from a specific view controller. The Beacon view controller will be presented as a modal.
  func open(settings: HSBeaconSettings, route: HSBeaconRoute, parameter: String?) throws
  /// Logs the current Beacon user out and clears out their information from local storage.
  func clear() throws
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class HelpScoutBeaconApiSetup {
  /// The codec used by HelpScoutBeaconApi.
  static var codec: FlutterStandardMessageCodec { HelpScoutBeaconApiCodec.shared }
  /// Sets up an instance of `HelpScoutBeaconApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: HelpScoutBeaconApi?) {
    /// Signs in with a Beacon user. This gives Beacon access to the user’s name, email address, and signature.
    let identifyChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.help_scout_beacon.HelpScoutBeaconApi.identify", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      identifyChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let beaconUserArg = args[0] as! HSBeaconUser
        do {
          try api.identify(beaconUser: beaconUserArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      identifyChannel.setMessageHandler(nil)
    }
    /// Opens the Beacon SDK from a specific view controller. The Beacon view controller will be presented as a modal.
    let openChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.help_scout_beacon.HelpScoutBeaconApi.open", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      openChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let settingsArg = args[0] as! HSBeaconSettings
        let routeArg = HSBeaconRoute(rawValue: args[1] as! Int)!
        let parameterArg: String? = nilOrValue(args[2])
        do {
          try api.open(settings: settingsArg, route: routeArg, parameter: parameterArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      openChannel.setMessageHandler(nil)
    }
    /// Logs the current Beacon user out and clears out their information from local storage.
    let clearChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.help_scout_beacon.HelpScoutBeaconApi.clear", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      clearChannel.setMessageHandler { _, reply in
        do {
          try api.clear()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      clearChannel.setMessageHandler(nil)
    }
  }
}
