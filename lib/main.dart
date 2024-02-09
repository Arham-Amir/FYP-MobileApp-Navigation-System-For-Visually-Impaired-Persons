import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:beyond_vis/uploadImage.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'navigateScreen.dart';
import 'helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

late List<CameraDescription> cameras;
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  runApp(
    MaterialApp(
      routes: {
        '/': (context) => const MyApp(),
        '/yoloOnFrame': (context) => const YoloVideo(),
        '/yoloOnImage': (context) => const ImageUploadScreen(),
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
  final picker = ImagePicker();

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

  Future<void> makeHttpRequest() async {
    final url = Uri.parse('http://1392-34-74-31-196.ngrok.io/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('HTTP Request Successful');
    } else {
      print('HTTP Request Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    makeHttpRequest();
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'lib/assets/background.png',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 2 / 3,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                "Choose Task",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
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
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: 'Navigation on Gallery Image',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                Navigator.pushNamed(context, '/yoloOnImage');
              });
            },
          ),
        ],
      ),
    );
  }
}
