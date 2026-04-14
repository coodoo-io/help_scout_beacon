import Flutter
import UIKit
import Beacon

public class HelpScoutBeaconPlugin: NSObject, FlutterPlugin, HelpScoutBeaconApi {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger : FlutterBinaryMessenger = registrar.messenger()
    let api : HelpScoutBeaconApi & NSObjectProtocol = HelpScoutBeaconPlugin.init()
    HelpScoutBeaconApiSetup.setUp(binaryMessenger: messenger, api: api)
  }

  func setup(settings: HSBeaconSettings) -> Void {
    // No needed for the swift API
  }

  /// Signs in with a Beacon user. This gives Beacon access to the user’s name, email address, and signature.
  func identify(beaconUser: HSBeaconUser) -> Void {
    let user = Beacon.HSBeaconUser()
    user.email = beaconUser.email
    user.name = beaconUser.name
    user.company = beaconUser.company
    user.jobTitle = beaconUser.jobTitle
    user.avatar = beaconUser.avatar != nil ? URL(string: beaconUser.avatar!) : nil

    if let attributes = beaconUser.attributes {
        for (key, value) in attributes {
            guard let unwrappedKey = key else { continue }
            let stringKey = String(describing: unwrappedKey)
            let stringValue = value != nil ? String(describing: value!) : ""
            user.addAttribute(withKey: stringKey, value: stringValue)
        }
    }

    Beacon.HSBeacon.identify(user)
  }

  /// Opens the Beacon SDK from a specific view controller. The Beacon view controller will be presented as a modal.
  func open(settings: HSBeaconSettings, route: HSBeaconRoute, parameter: String?) -> Void {
    var fMode : Beacon.HSBeaconFocusMode? = switch settings.focusMode {
        case .neutral:
          Beacon.HSBeaconFocusMode.neutral
        case .selfService:
          Beacon.HSBeaconFocusMode.selfService
        case .askFirst:
          Beacon.HSBeaconFocusMode.askFirst
        default:
          nil
      }

    let settings = Beacon.HSBeaconSettings(beaconId: settings.beaconId)
    settings.beaconTitle = settings.beaconTitle;
    settings.docsEnabled = settings.docsEnabled;
    settings.messagingEnabled = settings.messagingEnabled;
    settings.chatEnabled = settings.chatEnabled;
    settings.enablePreviousMessages = settings.enablePreviousMessages;
    if(fMode != nil) {
      settings.focusModeOverride = fMode!;
    }

    // method to be called when the user navigates to the contact form.
    settings.delegate = BeaconPrefillDelegate.shared

    switch route {
      case .ask:
        Beacon.HSBeacon.navigate(BeaconRoute.ask, settings: settings) // ask screen
      case .chat:
        Beacon.HSBeacon.navigate(BeaconRoute.askChat, settings: settings) // chat
      case .docs:
        if(parameter==nil || parameter == "") {
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

  /// Receives pre-fill data from Flutter and stores it in the singleton delegate.
  /// This data will be used later when the `prefill` delegate method is called by the SDK.
  func prefillContactForm(subject: String?, message: String?, attachments: [String]?) {
      let delegate = BeaconPrefillDelegate.shared
      delegate.subject = subject
      delegate.message = message
      delegate.attachments = attachments
  }
}

// A singleton delegate class to handle pre-filling the Help Scout Beacon contact form.
class BeaconPrefillDelegate: NSObject, HSBeaconDelegate {

    static let shared = BeaconPrefillDelegate()
    var subject: String?
    var message: String?
    var attachments: [String]?

    // This delegate method is called by the Beacon SDK just before the contact form is displayed.
    func prefill(_ form: HSBeaconContactForm) {
        form.subject = self.subject ?? ""
        form.text = self.message ?? ""

        guard let attachmentPaths = self.attachments, !attachmentPaths.isEmpty else {
            return
        }

        // Iterate over each file path and create a data attachment.
        attachmentPaths.forEach { path in
            let fileUrl = URL(fileURLWithPath: path)
            let filename = fileUrl.lastPathComponent

            do {
                if FileManager.default.fileExists(atPath: path) {
                    let fileData = try Data(contentsOf: fileUrl)
                    form.addAttachment(filename, data: fileData)
                }
            } catch {
                // Silently fail if the file cannot be read, to avoid crashing the app.
            }
        }
    }
}
