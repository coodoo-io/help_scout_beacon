import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:help_scout_beacon/help_scout_beacon.dart';
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
                    const sampleText = 'This is a sample attachment';

                    // Attachments are only supported on iOS/Android; the web
                    // Beacon prefill API ignores them.
                    List<XFile>? attachments;
                    if (!kIsWeb) {
                      final directory = await getApplicationDocumentsDirectory();
                      // File(...) just builds a path; writeAsString creates it on disk.
                      final file = File('${directory.path}/sample.txt');
                      await file.writeAsString(sampleText);
                      attachments = [XFile(file.path)];
                    }

                    //call prefillContactForm with subject, message and attachments
                    await beacon.prefillContactForm(
                      subject: 'Help Scout',
                      message: 'This is sample prefilled message',
                      attachments: attachments,
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
