import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:help_scout_beacon/help_scout_beacon.dart';
import 'package:help_scout_beacon/help_scout_beacon_api.g.dart';
import 'package:path_provider/path_provider.dart';

/// YOUR HELPSCOUT BEACON ID
const String yourBeaconId = "";

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
  final _formKey = GlobalKey<FormState>();
  final HelpScoutBeacon beacon = HelpScoutBeacon(
      HSBeaconSettings(beaconId: yourBeaconId, debugLogging: true));

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 16, width: 16);

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
              const Text("BeaconId: \n$yourBeaconId"),

              spacer,

              // Start a beacon ui
              ElevatedButton(
                onPressed: () => beacon.open(),
                child: const Text('Open (Default)'),
              ),
              spacer,

              ElevatedButton(
                onPressed: () => beacon.open(route: HSBeaconRoute.ask),
                child: const Text('Open Ask'),
              ),
              spacer,

              ElevatedButton(
                onPressed: () => beacon.open(route: HSBeaconRoute.chat),
                child: const Text('Open Chat'),
              ),
              spacer,

              ElevatedButton(
                onPressed: () => beacon.open(route: HSBeaconRoute.docs),
                child: const Text('Open Docs'),
              ),
              spacer,

              ElevatedButton(
                onPressed: () =>
                    beacon.open(route: HSBeaconRoute.docs, parameter: 'Help'),
                child: const Text('Open Docs (+search term)'),
              ),
              spacer,

              ElevatedButton(
                onPressed: () => beacon.open(route: HSBeaconRoute.contactForm),
                child: const Text('Open Contact Form'),
              ),
              spacer,

              ElevatedButton(
                onPressed: () async {
                  try {
                    final logs = ['This is a sample logs text'];
                    final logsJsonString = logs.join('\n');

                    final directory = await getApplicationDocumentsDirectory();
                    final logFile = File('${directory.path}/session_logs.txt'); //Create new file
                    await logFile.writeAsString(logsJsonString);  //Write data or logs into the file
                    
                    //call prefillContactForm with subject, message and attachments
                    await beacon.prefillContactForm(
                      subject: 'Help Scout',
                      message: 'This is sample prefilled message',
                      attachments: [logFile],
                    );
                    // Now open contactForm
                    beacon.open(route: HSBeaconRoute.contactForm);
                  } on Exception catch (e) {
                    if (kDebugMode) {
                      print('open exception: $e');
                    }
                  }
                },
                child: const Text('Open Prefilled Contact Form'),
              ),
              spacer,

              ElevatedButton(
                onPressed: () =>
                    beacon.open(route: HSBeaconRoute.previousMessages),
                child: const Text('Open Previous Messages'),
              ),

              const SizedBox(height: 32),

              // Clear everything
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () => beacon.identify(
                        beaconUser: HSBeaconUser(
                            email: "john.doe@example.com", name: "John Doe")),
                    child: const Text('Set User'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: clearBeacon,
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

  Future<void>? clearBeacon() async {
    await beacon.clear();
  }

  bool isFormValid() {
    return _formKey.currentState?.validate() ?? false;
  }
}
