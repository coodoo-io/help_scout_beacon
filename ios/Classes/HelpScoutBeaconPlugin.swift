import Flutter
import UIKit
import Beacon

public class HelpScoutBeaconPlugin: NSObject, FlutterPlugin, HelpScoutBeaconApi {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger : FlutterBinaryMessenger = registrar.messenger()
    let api : HelpScoutBeaconApi & NSObjectProtocol = HelpScoutBeaconPlugin.init()
    HelpScoutBeaconApiSetup.setUp(binaryMessenger: messenger, api: api)
  }

  /// Signs in with a Beacon user. This gives Beacon access to the user’s name, email address, and signature.
  func identify(beaconUser: HSBeaconUser) -> Void {}
  /// Opens the Beacon SDK from a specific view controller. The Beacon view controller will be presented as a modal.
  func open(settings: HSBeaconSettings, route: HSBeaconRoute, parameter: String?) -> Void {
    let settings = Beacon.HSBeaconSettings(beaconId: settings.beaconId)
    Beacon.HSBeacon.open(settings)
  }
  /// Logs the current Beacon user out and clears out their information from local storage.
  func logout() -> Void {
    Beacon.HSBeacon.logout()
  }
}
