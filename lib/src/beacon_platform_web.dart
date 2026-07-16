import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:cross_file/cross_file.dart';
import 'package:web/web.dart' as web;

import 'package:help_scout_beacon/help_scout_beacon_api.g.dart';
import 'package:help_scout_beacon/src/beacon_platform.dart';

BeaconPlatform createBeaconPlatform() => BeaconPlatformWeb();

/// Global `window.Beacon(method, options)` function installed by the loader.
@JS('Beacon')
external void _beacon(String method, [JSAny? options]);

/// The beaconId Beacon is currently initialized with, or null if not yet
/// initialized. Library-level (not instance) state, because [HelpScoutBeacon]
/// constructs a fresh platform instance on every call — instance state would
/// never see the previous init and would re-`init` each time (Help Scout then
/// warns "Beacon has already been initialized").
String? _initializedBeaconId;

/// Web implementation backed by the Help Scout Beacon JS SDK.
///
/// Docs: https://developer.helpscout.com/beacon-2/web/javascript-api/
class BeaconPlatformWeb implements BeaconPlatform {
  bool _loaderInjected = false;

  /// Injects the official Beacon async loader snippet once. After this runs,
  /// `window.Beacon(...)` calls are queued until beacon-v2.js finishes loading.
  void _ensureLoader() {
    if (_loaderInjected || globalContext.has('Beacon')) {
      _loaderInjected = true;
      return;
    }
    final script = web.HTMLScriptElement()
      ..type = 'text/javascript'
      ..text =
          '!function(e,t,n){function a(){var e=t.getElementsByTagName("script")[0],'
          'n=t.createElement("script");n.type="text/javascript",n.async=!0,'
          'n.src="https://beacon-v2.helpscout.net",e.parentNode.insertBefore(n,e)}'
          'if(e.Beacon=n=function(t,n,a){e.Beacon.readyQueue.push({method:t,options:n,data:a})},'
          'n.readyQueue=[],"complete"===t.readyState)return a();'
          'e.attachEvent?e.attachEvent("onload",a):e.addEventListener("load",a,!1)}'
          '(window,document,window.Beacon||function(){});';
    web.document.head!.appendChild(script);
    _loaderInjected = true;
  }

  @override
  Future<void> setup(HSBeaconSettings settings) async {
    _ensureLoader();
    // Init exactly once per beaconId. Re-initing an already-initialized Beacon
    // makes Help Scout log "Beacon has already been initialized".
    if (_initializedBeaconId == settings.beaconId) return;
    // Switching beaconId (e.g. a locale change) requires tearing down first.
    if (_initializedBeaconId != null) _beacon('destroy');
    _beacon('init', settings.beaconId.toJS);
    _initializedBeaconId = settings.beaconId;
    // NOTE: docs/chat/messaging visibility on web is governed by the Beacon
    // Builder config in Help Scout, not the JS API. The native-only toggles on
    // [HSBeaconSettings] (docsEnabled/chatEnabled/...) therefore have no web
    // equivalent here; route directly to the desired screen via [open] instead.
  }

  @override
  Future<void> identify(HSBeaconUser beaconUser) async {
    final data = <String, Object?>{
      'email': beaconUser.email,
      if (beaconUser.name != null) 'name': beaconUser.name,
      if (beaconUser.company != null) 'company': beaconUser.company,
      if (beaconUser.jobTitle != null) 'jobTitle': beaconUser.jobTitle,
      if (beaconUser.avatar != null) 'avatar': beaconUser.avatar,
      ...?beaconUser.attributes?.map((k, v) => MapEntry(k.toString(), v)),
    };
    _beacon('identify', data.jsify());
  }

  @override
  Future<void> open(HSBeaconSettings settings, HSBeaconRoute route, String? parameter) async {
    _ensureLoader();
    switch (route) {
      case HSBeaconRoute.ask:
        _beacon('navigate', '/'.toJS);
      case HSBeaconRoute.chat:
        _beacon('navigate', '/ask/chat/'.toJS);
      case HSBeaconRoute.docs:
        if (parameter != null && parameter.isNotEmpty) {
          _beacon('search', parameter.toJS);
        } else {
          _beacon('navigate', '/answers/'.toJS);
        }
      case HSBeaconRoute.article:
        if (parameter != null) _beacon('article', parameter.toJS);
      case HSBeaconRoute.contactForm:
        _beacon('navigate', '/ask/message/'.toJS);
      case HSBeaconRoute.previousMessages:
        _beacon('navigate', '/previous-messages/'.toJS);
    }
    _beacon('open');
  }

  @override
  Future<void> clear() async => _beacon('logout');

  @override
  Future<void> prefillContactForm(String? subject, String? message, List<XFile>? attachments) async {
    // Web Beacon prefill supports form fields only — attachments are ignored.
    final data = <String, Object?>{
      if (subject != null) 'subject': subject,
      if (message != null) 'text': message,
    };
    _beacon('prefill', data.jsify());
  }
}
