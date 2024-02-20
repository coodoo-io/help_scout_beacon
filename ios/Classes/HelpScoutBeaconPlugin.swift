import Flutter
import UIKit
import Beacon

public class HelpScoutBeaconPlugin: NSObject, FlutterPlugin, HelpScoutApi {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger : FlutterBinaryMessenger = registrar.messenger()
    let api : HelpScoutApi & NSObjectProtocol = HelpScoutBeaconPlugin.init()
    HelpScoutApiSetup.setUp(binaryMessenger: messenger, api: api)
  }

  func initialize(beaconId: String) -> Void {
    let settings = HSBeaconSettings(beaconId: beaconId)
    HSBeacon.open(settings)
  }

  // open a beacon ui
  func open() -> Void {
    
  }

  // logout identity from beacon
  func logout() -> Void {
    HSBeacon.logout()
  }

  // clear all beacon data
  func clear() -> Void {
    HSBeacon.reset()
  }

}
