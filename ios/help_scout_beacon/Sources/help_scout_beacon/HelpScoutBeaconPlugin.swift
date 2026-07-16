import Beacon
import Flutter
import UIKit

public final class HelpScoutBeaconPlugin: NSObject, FlutterPlugin, HelpScoutBeaconApi {
  public static func register(with registrar: FlutterPluginRegistrar) {
    HelpScoutBeaconApiSetup.setUp(
      binaryMessenger: registrar.messenger(),
      api: HelpScoutBeaconPlugin()
    )
  }

  /// Initialize the beacon with a beaconId and optional settings.
  func setup(settings: HSBeaconSettings) {
    // Nothing to do here: the iOS SDK takes its settings when a screen is opened, see `open`.
  }

  /// Signs in with a Beacon user. This gives Beacon access to the user’s name, email address, and signature.
  func identify(beaconUser: HSBeaconUser) {
    let user = Beacon.HSBeaconUser()
    user.email = beaconUser.email
    user.name = beaconUser.name
    user.company = beaconUser.company
    user.jobTitle = beaconUser.jobTitle
    user.avatar = beaconUser.avatar.flatMap { URL(string: $0) }

    for (key, value) in beaconUser.attributes ?? [:] {
      guard let key else { continue }
      user.addAttribute(
        withKey: String(describing: key),
        value: value.map { String(describing: $0) } ?? ""
      )
    }

    Beacon.HSBeacon.identify(user)
  }

  /// Opens the Beacon SDK from a specific view controller. The Beacon view controller will be presented as a modal.
  func open(settings: HSBeaconSettings, route: HSBeaconRoute, parameter: String?) {
    let beaconSettings = Beacon.HSBeaconSettings(beaconId: settings.beaconId)

    // Only override what Flutter actually set; the rest stays on the Beacon Builder config.
    // `beaconTitle` is deliberately not forwarded: the SDK deprecated it and it has no effect —
    // the title comes from the Beacon Builder config.
    if let docsEnabled = settings.docsEnabled {
      beaconSettings.docsEnabled = docsEnabled
    }
    if let messagingEnabled = settings.messagingEnabled {
      beaconSettings.messagingEnabled = messagingEnabled
    }
    if let chatEnabled = settings.chatEnabled {
      beaconSettings.chatEnabled = chatEnabled
    }
    beaconSettings.enablePreviousMessages = settings.enablePreviousMessages

    if let focusMode = settings.focusMode {
      switch focusMode {
      case .neutral:
        beaconSettings.focusModeOverride = .neutral
      case .selfService:
        beaconSettings.focusModeOverride = .selfService
      case .askFirst:
        beaconSettings.focusModeOverride = .askFirst
      }
    }

    // Called back when the user navigates to the contact form.
    beaconSettings.delegate = BeaconPrefillDelegate.shared

    switch route {
    case .ask:
      Beacon.HSBeacon.navigate(BeaconRoute.ask, settings: beaconSettings)
    case .chat:
      Beacon.HSBeacon.navigate(BeaconRoute.askChat, settings: beaconSettings)
    case .docs:
      if let parameter, !parameter.isEmpty {
        Beacon.HSBeacon.navigate(BeaconRoute.search(parameter), settings: beaconSettings)
      } else {
        Beacon.HSBeacon.navigate(BeaconRoute.answers, settings: beaconSettings)
      }
    case .article:
      Beacon.HSBeacon.navigate(BeaconRoute.article(parameter ?? ""), settings: beaconSettings)
    case .contactForm:
      Beacon.HSBeacon.navigate(BeaconRoute.askMessage, settings: beaconSettings)
    case .previousMessages:
      Beacon.HSBeacon.navigate(BeaconRoute.previousMessages, settings: beaconSettings)
    }
  }

  /// Logs the current Beacon user out and clears out their information from local storage.
  func clear() {
    Beacon.HSBeacon.logout()
  }

  /// Receives pre-fill data from Flutter and stores it in the singleton delegate.
  /// This data will be used later when the `prefill` delegate method is called by the SDK.
  func prefillContactForm(subject: String?, message: String?, attachments: [String]?) {
    BeaconPrefillDelegate.shared.update(
      subject: subject,
      message: message,
      attachments: attachments
    )
  }
}

/// A singleton delegate class to handle pre-filling the Help Scout Beacon contact form.
///
/// `update` is called from the platform channel and `prefill` by the SDK when the form is about
/// to be shown, so the stored data is lock-protected rather than isolated to an actor: both
/// `FlutterPlugin` and `HSBeaconDelegate` are non-isolated protocols from other modules.
final class BeaconPrefillDelegate: NSObject, HSBeaconDelegate, @unchecked Sendable {
  static let shared = BeaconPrefillDelegate()

  private let lock = NSLock()
  private var subject: String?
  private var message: String?
  private var attachments: [String]?

  func update(subject: String?, message: String?, attachments: [String]?) {
    lock.lock()
    defer { lock.unlock() }
    self.subject = subject
    self.message = message
    self.attachments = attachments
  }

  /// This delegate method is called by the Beacon SDK just before the contact form is displayed.
  func prefill(_ form: HSBeaconContactForm) {
    lock.lock()
    let subject = self.subject
    let message = self.message
    let attachments = self.attachments
    lock.unlock()

    form.subject = subject ?? ""
    form.text = message ?? ""

    for path in attachments ?? [] {
      let fileUrl = URL(fileURLWithPath: path)
      // Silently skip files that cannot be read, to avoid crashing the app.
      guard FileManager.default.fileExists(atPath: path),
        let fileData = try? Data(contentsOf: fileUrl)
      else { continue }
      form.addAttachment(fileUrl.lastPathComponent, data: fileData)
    }
  }
}
