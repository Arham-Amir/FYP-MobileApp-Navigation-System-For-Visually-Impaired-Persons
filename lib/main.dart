import 'dart:async';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'navigateScreen.dart';
import 'helper.dart';

late List<CameraDescription> cameras;
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  runApp(
    MaterialApp(
      routes: {
        '/': (context) => const MyApp(),
        '/yoloOnFrame': (context) => const YoloVideo(),
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Helper helper = Helper();

  @override
  void initState() {
    super.initState();
    helper
        .speak("خوش آمدید، چلنے مین رہنُمائی کے لئے 'Start Navigation' بولیے")
        .then((_) {
      setState(() {
        Timer(const Duration(seconds: 3), () {
          startListening();
        });
      });
    });
  }

  void startListening() {
    helper.startListening((command) {
      processCommand(command);
    });
  }

  void processCommand(String command) {
    print(">>>>>>>>> $command");
    if (command.toLowerCase().contains('start navigation')) {
      Navigator.pushNamed(context, '/yoloOnFrame');
    }
  }

  @override
  void dispose() async {
    super.dispose();
    helper.stopListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: task(),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: Colors.black12,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.deepPurpleAccent,
        activeForegroundColor: Colors.white,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        buttonSize: const Size(56.0, 56.0),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.video_call),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Yolo on Frame',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                Navigator.pushNamed(context, '/yoloOnFrame');
              });
            },
          ),
        ],
      ),
    );
  }

  Widget task() {
    return const Center(child: Text("Choose Task"));
  }
}
