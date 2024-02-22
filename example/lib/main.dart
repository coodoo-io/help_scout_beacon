import 'package:flutter/material.dart';
import 'package:help_scout_beacon/help_scout_beacon.dart';
import 'package:help_scout_beacon/help_scout_beacon_api.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _beaconId = "";
  final HelpScoutBeacon _beacon = HelpScoutBeacon();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Help Scout Plugin'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Enter your beacon id
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  onChanged: (value) => setState(() => _beaconId = value),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                    labelText: 'Beacon ID',
                    hintText: 'Enter your beacon ID',
                    contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Start a beacon ui
              ElevatedButton(
                onPressed: () =>
                    _beacon.open(settings: HSBeaconSettings(beaconId: _beaconId), route: HSBeaconRoute.ask),
                child: const Text('Open Ask'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    _beacon.open(settings: HSBeaconSettings(beaconId: _beaconId), route: HSBeaconRoute.chat),
                child: const Text('Open Chat'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _beacon.open(
                    settings: HSBeaconSettings(beaconId: _beaconId), route: HSBeaconRoute.search, parameter: 'wann'),
                child: const Text('Open Docs Search'),
              ),
              const SizedBox(height: 32),

              // Clear everything
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () =>
                        _beacon.identify(beaconUser: HSBeaconUser(email: "john.doe@example.com", name: "John Doe")),
                    child: const Text('Set User'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () => _beacon.logout(),
                    child: const Text('Clear User'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
