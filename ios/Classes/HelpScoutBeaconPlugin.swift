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
  func identify(beaconUser: HSBeaconUser) -> Void {
    let user = Beacon.HSBeaconUser()
    user.email = beaconUser.email
    user.name = beaconUser.name
    user.company = beaconUser.company
    user.jobTitle = beaconUser.jobTitle
    user.avatar = beaconUser.avatar != nil ? URL(string: beaconUser.avatar!) : nil
    
    Beacon.HSBeacon.identify(user)
  }

  /// Opens the Beacon SDK from a specific view controller. The Beacon view controller will be presented as a modal.
  func open(settings: HSBeaconSettings, route: HSBeaconRoute, parameter: String?) -> Void {
    let settings = Beacon.HSBeaconSettings(beaconId: settings.beaconId)
    switch route {
      case .ask:
        Beacon.HSBeacon.navigate(BeaconRoute.ask, settings: settings) // ask screen
      case .chat:
        Beacon.HSBeacon.navigate(BeaconRoute.askChat, settings: settings) // chat
      case .docs:
        if(parameter==nil || parameter == "") {
          Beacon.HSBeacon.navigate(BeaconRoute.answers,settings: settings) // Open docs
        } else {
          Beacon.HSBeacon.navigate(BeaconRoute.search(parameter!), settings: settings) // Open docs with search query
        }
      case .article:
        Beacon.HSBeacon.navigate(BeaconRoute.article(parameter ?? ""), settings: settings) // Open an article
      case .contactForm:
        Beacon.HSBeacon.navigate(BeaconRoute.askMessage, settings: settings) // contact-form screen
      case .previousMessages:
        Beacon.HSBeacon.navigate(BeaconRoute.previousMessages, settings: settings) // previous conversations screen
      default:
        Beacon.HSBeacon.open(settings)
      }
  }

  /// Logs the current Beacon user out and clears out their information from local storage.
  func clear() -> Void {
    Beacon.HSBeacon.logout()
  }
}
