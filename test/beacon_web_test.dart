@TestOn('browser')
library;

import 'dart:js_interop';

import 'package:flutter_test/flutter_test.dart';
import 'package:help_scout_beacon/help_scout_beacon.dart';
import 'package:web/web.dart' as web;

@JS('Beacon')
external JSAny? get _beacon;

/// Calls recorded by the stub installed in [_stubBeacon].
@JS('__calls')
external JSArray<JSAny?>? get _calls;

/// Replaces the real loader with a stub that records `Beacon(...)` calls, so
/// tests can assert on them without hitting the network.
void _stubBeacon() {
  final script = web.HTMLScriptElement()
    ..type = 'text/javascript'
    ..text = 'window.__calls = [];'
        'window.Beacon = function (m, o) { window.__calls.push(m); };';
  web.document.head!.appendChild(script);
}

List<String> get _recorded =>
    (_calls?.toDart ?? const <JSAny?>[]).map((e) => (e as JSString).toDart).toList();

void main() {
  test('logout() does not throw when the beacon was never opened', () async {
    // No stub and no setup: window.Beacon is undefined. The loader must be
    // injected before the call, otherwise this throws a JS TypeError.
    expect(_beacon, isNull, reason: 'precondition: Beacon must not exist yet');
    await expectLater(HelpScoutBeacon.logout(), completes);
    expect(_beacon, isNotNull, reason: 'logout() should have injected the loader');
  });

  test('identify() and open() route through the JS Beacon', () async {
    _stubBeacon();
    final beacon = HelpScoutBeacon(HSBeaconSettings(beaconId: 'test-id'));
    await beacon.ready;

    await beacon.identify(beaconUser: HSBeaconUser(email: 'a@b.c'));
    await beacon.open(route: HSBeaconRoute.contactForm);

    expect(_recorded, containsAll(<String>['init', 'identify', 'navigate', 'open']));
  });

  test('setup() inits only once for the same beaconId', () async {
    _stubBeacon();
    final settings = HSBeaconSettings(beaconId: 'same-id');
    await HelpScoutBeacon(settings).ready;
    final before = _recorded.where((c) => c == 'init').length;

    await HelpScoutBeacon(settings).ready;
    final after = _recorded.where((c) => c == 'init').length;

    expect(after, before, reason: 'a second beacon with the same id must not re-init');
  });
}
