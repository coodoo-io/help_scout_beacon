import 'package:flutter/material.dart';
import 'package:help_scout_beacon/help_scout_beacon.dart';

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
                onPressed: () {
                  HelpScoutBeacon()
                    ..initialize(beaconId: '3a08bb62-4a31-4d40-8cae-31c084c16c89')
                    ..open();
                },
                child: const Text('Open Beacon-UI'),
              ),

              const SizedBox(height: 16),

              // Clear everything
              OutlinedButton(
                onPressed: () => HelpScoutBeacon().logout(),
                child: const Text('Logout identity'),
              ),
              
              const SizedBox(height: 16),

              // Clear everything
              OutlinedButton(
                onPressed: () => HelpScoutBeacon().clear(),
                child: const Text('Clear beacon'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
