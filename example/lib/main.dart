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
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Help Scout Plugin'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Enter your beacon id
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    onChanged: (value) => setState(() => _beaconId = value),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      labelText: 'Beacon ID',
                      hintText: 'Enter your beacon ID',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 3) {
                        return 'Missing beacon ID from helpscout.com';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Start a beacon ui
              ElevatedButton(
                onPressed: isFormValid()
                    ? () => _beacon.open(
                        settings: HSBeaconSettings(beaconId: _beaconId))
                    : null,
                child: const Text('Open (Default)'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isFormValid()
                    ? () => _beacon.open(
                        settings: HSBeaconSettings(beaconId: _beaconId),
                        route: HSBeaconRoute.ask)
                    : null,
                child: const Text('Open Ask'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isFormValid()
                    ? () => _beacon.open(
                        settings: HSBeaconSettings(beaconId: _beaconId),
                        route: HSBeaconRoute.chat)
                    : null,
                child: const Text('Open Chat'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isFormValid()
                    ? () => _beacon.open(
                        settings: HSBeaconSettings(beaconId: _beaconId),
                        route: HSBeaconRoute.docs)
                    : null,
                child: const Text('Open Docs'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isFormValid()
                    ? () => _beacon.open(
                        settings: HSBeaconSettings(beaconId: _beaconId),
                        route: HSBeaconRoute.docs,
                        parameter: 'Help')
                    : null,
                child: const Text('Open Docs (+search term)'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isFormValid()
                    ? () => _beacon.open(
                        settings: HSBeaconSettings(beaconId: _beaconId),
                        route: HSBeaconRoute.contactForm)
                    : null,
                child: const Text('Open Contact Form'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isFormValid()
                    ? () => _beacon.open(
                        settings: HSBeaconSettings(beaconId: _beaconId),
                        route: HSBeaconRoute.previousMessages)
                    : null,
                child: const Text('Open Previous Messages'),
              ),
              const SizedBox(height: 32),

              // Clear everything
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: isFormValid()
                        ? () => _beacon.identify(
                            beaconUser: HSBeaconUser(
                                email: "john.doe@example.com",
                                name: "John Doe"))
                        : null,
                    child: const Text('Set User'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: isFormValid() ? () => _beacon.clear() : null,
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isFormValid() {
    return _formKey.currentState?.validate() ?? false;
  }
}
