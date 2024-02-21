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
                onPressed: () => HelpScoutBeacon.open(
                    settings: HSBeaconSettings(beaconId: 'b3e675c8-77c1-4c80-92b6-c2b30ac71dcd')),
                child: const Text('Open Beacon-UI'),
              ),

              const SizedBox(height: 16),

              // Clear everything
              OutlinedButton(
                onPressed: () => HelpScoutBeacon.identify(beaconUser: HSBeaconUser(email: "john.doe@example.com")),
                child: const Text('Identity User'),
              ),

              const SizedBox(height: 16),

              // Logout
              OutlinedButton(
                onPressed: () => HelpScoutBeacon.logout(),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
