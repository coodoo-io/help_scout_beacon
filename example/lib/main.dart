import 'package:flutter/material.dart';
import 'package:help_scout_beacon/help_scout_beacon.dart';
import 'package:help_scout_beacon/help_scout_beacon_api.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
              // Start a beacon ui
              ElevatedButton(
                onPressed: () =>
                    HelpScoutBeacon.open(settings: HSBeaconSettings(beaconId: '3a08bb62-4a31-4d40-8cae-31c084c16c89')),
                child: const Text('Open Beacon-UI'),
              ),

              const SizedBox(height: 32),

              // Clear everything
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => HelpScoutBeacon.identify(
                        beaconUser: HSBeaconUser(email: "john.doe@example.com", name: "John Doe")),
                    child: const Text('Set User'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () => HelpScoutBeacon.logout(),
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
