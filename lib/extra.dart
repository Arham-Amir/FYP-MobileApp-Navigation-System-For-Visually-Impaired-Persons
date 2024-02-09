// // // // ignore_for_file: library_private_types_in_public_api
// // // import 'package:beyond_vis/views/camera_view.dart';
// // // import 'package:flutter/material.dart';
// // //
// // // Future<void> main() async {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   runApp(const MyApp());
// // // }
// // //
// // // class MyApp extends StatelessWidget {
// // //   const MyApp({Key? key}) : super(key: key);
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return const MaterialApp(home: CameraView());
// // //   }
// // // }

// // // import 'dart:io';
// // // import 'dart:typed_data';
// // // import 'dart:ui';

// // // import 'package:camera/camera.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/services.dart';
// // // import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// // // import 'dart:async';
// // // import 'package:flutter_vision/flutter_vision.dart';
// // // import 'package:flutter_tflite/flutter_tflite.dart';
// // // import 'package:image_picker/image_picker.dart';

// // // enum Options { none, imagev5, imagev8, imagev8seg, frame, tesseract, vision }

// // // late List<CameraDescription> cameras;
// // // main() async {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   DartPluginRegistrant.ensureInitialized();
// // //   runApp(
// // //     const MaterialApp(
// // //       home: MyApp(),
// // //     ),
// // //   );
// // // }

// // // class MyApp extends StatefulWidget {
// // //   const MyApp({Key? key}) : super(key: key);

// // //   @override
// // //   State<MyApp> createState() => _MyAppState();
// // // }

// // // class _MyAppState extends State<MyApp> {
// // //   late FlutterVision vision;
// // //   Options option = Options.none;
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     // vision = FlutterVision();
// // //   }

// // //   @override
// // //   void dispose() async {
// // //     super.dispose();
// // //     // await vision.closeTesseractModel();
// // //     // await vision.closeYoloModel();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       body: task(option),
// // //       floatingActionButton: SpeedDial(
// // //         //margin bottom
// // //         icon: Icons.menu, //icon on Floating action button
// // //         activeIcon: Icons.close, //icon when menu is expanded on button
// // //         backgroundColor: Colors.black12, //background color of button
// // //         foregroundColor: Colors.white, //font color, icon color in button
// // //         activeBackgroundColor:
// // //             Colors.deepPurpleAccent, //background color when menu is expanded
// // //         activeForegroundColor: Colors.white,
// // //         visible: true,
// // //         closeManually: false,
// // //         curve: Curves.bounceIn,
// // //         overlayColor: Colors.black,
// // //         overlayOpacity: 0.5,
// // //         buttonSize: const Size(56.0, 56.0),
// // //         children: [
// // //           SpeedDialChild(
// // //             //speed dial child
// // //             child: const Icon(Icons.video_call),
// // //             backgroundColor: Colors.red,
// // //             foregroundColor: Colors.white,
// // //             label: 'Yolo on Frame',
// // //             labelStyle: const TextStyle(fontSize: 18.0),
// // //             onTap: () {
// // //               setState(() {
// // //                 option = Options.frame;
// // //               });
// // //             },
// // //           )
// // //           // SpeedDialChild(
// // //           //   child: const Icon(Icons.document_scanner),
// // //           //   foregroundColor: Colors.white,
// // //           //   backgroundColor: Colors.green,
// // //           //   label: 'Vision',
// // //           //   labelStyle: const TextStyle(fontSize: 18.0),
// // //           //   onTap: () {
// // //           //     setState(() {
// // //           //       option = Options.vision;
// // //           //     });
// // //           //   },
// // //           // ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget task(Options option) {
// // //     if (option == Options.frame) {
// // //       return YoloVideo();
// // //     }
// // //     return const Center(child: Text("Choose Task"));
// // //   }
// // // }

// // // class YoloVideo extends StatefulWidget {
// // //   const YoloVideo({Key? key}) : super(key: key);

// // //   @override
// // //   State<YoloVideo> createState() => _YoloVideoState();
// // // }

// // // class _YoloVideoState extends State<YoloVideo> {
// // //   late CameraController controller;
// // //   late List<Map<String, dynamic>> yoloResults;
// // //   CameraImage? cameraImage;
// // //   bool isLoaded = false;
// // //   bool isDetecting = false;
// // //   bool isEvaluating = false;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     init();
// // //   }

// // //   init() async {
// // //     cameras = await availableCameras();
// // //     controller = CameraController(cameras[0], ResolutionPreset.medium);
// // //     controller.initialize().then((value) {
// // //       loadYoloModel().then((value) {
// // //         setState(() {
// // //           isLoaded = true;
// // //           isDetecting = false;
// // //           yoloResults = [];
// // //         });
// // //       });
// // //     });
// // //   }

// // //   @override
// // //   void dispose() async {
// // //     super.dispose();
// // //     controller.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final Size size = MediaQuery.of(context).size;
// // //     if (!isLoaded) {
// // //       return const Scaffold(
// // //         body: Center(
// // //           child: Text("Model not loaded, waiting for it"),
// // //         ),
// // //       );
// // //     }
// // //     return Stack(
// // //       fit: StackFit.expand,
// // //       children: [
// // //         AspectRatio(
// // //           aspectRatio: controller.value.aspectRatio,
// // //           child: CameraPreview(
// // //             controller,
// // //           ),
// // //         ),
// // //         ...displayBoxesAroundRecognizedObjects(size),
// // //         Positioned(
// // //           bottom: 75,
// // //           width: MediaQuery.of(context).size.width,
// // //           child: Container(
// // //             height: 80,
// // //             width: 80,
// // //             decoration: BoxDecoration(
// // //               shape: BoxShape.circle,
// // //               border: Border.all(
// // //                   width: 5, color: Colors.white, style: BorderStyle.solid),
// // //             ),
// // //             child: isDetecting
// // //                 ? IconButton(
// // //                     onPressed: () async {
// // //                       stopDetection();
// // //                     },
// // //                     icon: const Icon(
// // //                       Icons.stop,
// // //                       color: Colors.red,
// // //                     ),
// // //                     iconSize: 50,
// // //                   )
// // //                 : IconButton(
// // //                     onPressed: () async {
// // //                       await startDetection();
// // //                     },
// // //                     icon: const Icon(
// // //                       Icons.play_arrow,
// // //                       color: Colors.white,
// // //                     ),
// // //                     iconSize: 50,
// // //                   ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Future<void> loadYoloModel() async {
// // //     try {
// // //       Tflite.close();
// // //       String? res;
// // //       res = await Tflite.loadModel(
// // //           model: 'assets/yolov2_tiny.tflite', labels: 'assets/yolov2_tiny.txt');
// // //       print('loadModel: $res');
// // //     } on PlatformException {
// // //       print('Failed to load model.');
// // //     }
// // //   }

// // //   Future<void> yoloOnFrame(CameraImage image) async {
// // //     final recognitions = await Tflite.detectObjectOnFrame(
// // //       bytesList: image.planes.map((plane) {
// // //         return plane.bytes;
// // //       }).toList(),
// // //       model: "YOLO",
// // //       imageHeight: image.height,
// // //       imageWidth: image.width,
// // //       imageMean: 0,
// // //       imageStd: 255.0,
// // //       threshold: 0.2,
// // //       numResultsPerClass: 3,
// // //     );
// // //     print("----------------------------------");
// // //     print("recognitions: $recognitions");
// // //     print("----------------------------------");
// // //     // if (recognitions!.isNotEmpty) {
// // //     //   setState(() {
// // //     //     yoloResults = recognitions.cast<Map<String, dynamic>>();
// // //     //   });
// // //     // }
// // //     if (recognitions != null && recognitions.isNotEmpty) {
// // //       List<Map<String, dynamic>> formattedResults = recognitions.map((recog) {
// // //         return {
// // //           "tag": recog["detectedClass"],
// // //           "box": [
// // //             recog["rect"]["x"],
// // //             recog["rect"]["y"],
// // //             recog["rect"]["x"] + recog["rect"]["w"],
// // //             recog["rect"]["y"] + recog["rect"]["h"],
// // //             recog["confidenceInClass"]
// // //           ]
// // //         };
// // //       }).toList();
// // //       setState(() {
// // //         yoloResults = formattedResults;
// // //       });
// // //     }
// // //     setState(() {
// // //       isEvaluating = false;
// // //     });
// // //   }

// // //   Future<void> startDetection() async {
// // //     setState(() {
// // //       isDetecting = true;
// // //     });
// // //     if (controller.value.isStreamingImages) {
// // //       return;
// // //     }
// // //     await controller.startImageStream((image) async {
// // //       if (isDetecting && !isEvaluating) {
// // //         cameraImage = image;
// // //         try {
// // //           setState(() {
// // //             isEvaluating = true; // Mark as currently evaluating
// // //           });
// // //           yoloOnFrame(image);
// // //         } catch (e) {
// // //           print("Error running model: $e");
// // //           // Decide what to do: retry, show error, etc.
// // //         }
// // //       }
// // //     });
// // //   }

// // //   Future<void> stopDetection() async {
// // //     setState(() {
// // //       isDetecting = false;
// // //       yoloResults.clear();
// // //     });
// // //   }

// // //   List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
// // //     if (yoloResults.isEmpty) return [];

// // //     double factorX = screen.width;
// // //     double factorY = screen.height;

// // //     Color colorPick = const Color.fromARGB(255, 50, 233, 30);

// // //     return yoloResults.map((result) {
// // //       List<dynamic> box = result["box"];
// // //       double x = box[0];
// // //       double y = box[1];
// // //       double width = box[2] - box[0];
// // //       double height = box[3] - box[1];
// // //       double confidence = box[4];

// // //       return Positioned(
// // //         left: x * factorX,
// // //         top: y * factorY,
// // //         width: width * factorX,
// // //         height: height * factorY,
// // //         child: Container(
// // //           decoration: BoxDecoration(
// // //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
// // //             border: Border.all(color: Colors.pink, width: 2.0),
// // //           ),
// // //           child: Text(
// // //             "${result['tag']} ${(confidence * 100).toStringAsFixed(0)}%",
// // //             style: TextStyle(
// // //               background: Paint()..color = colorPick,
// // //               color: Colors.white,
// // //               fontSize: 18.0,
// // //             ),
// // //           ),
// // //         ),
// // //       );
// // //     }).toList();
// // //   }
// // // }

// // import 'dart:io';
// // import 'dart:typed_data';
// // import 'dart:ui';
// // import 'package:image/image.dart' as imglib;
// // import 'package:camera/camera.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// // import 'dart:async';
// // import 'package:flutter_vision/flutter_vision.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;

// // enum Options { none, imagev5, imagev8, imagev8seg, frame, tesseract, vision }

// // late List<CameraDescription> cameras;
// // main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   DartPluginRegistrant.ensureInitialized();
// //   runApp(
// //     const MaterialApp(
// //       home: MyApp(),
// //     ),
// //   );
// // }

// // class MyApp extends StatefulWidget {
// //   const MyApp({Key? key}) : super(key: key);

// //   @override
// //   State<MyApp> createState() => _MyAppState();
// // }

// // class _MyAppState extends State<MyApp> {
// //   late FlutterVision vision;
// //   Options option = Options.none;
// //   @override
// //   void initState() {
// //     super.initState();
// //     vision = FlutterVision();
// //   }

// //   @override
// //   void dispose() async {
// //     super.dispose();
// //     await vision.closeTesseractModel();
// //     await vision.closeYoloModel();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: task(option),
// //       floatingActionButton: SpeedDial(
// //         //margin bottom
// //         icon: Icons.menu, //icon on Floating action button
// //         activeIcon: Icons.close, //icon when menu is expanded on button
// //         backgroundColor: Colors.black12, //background color of button
// //         foregroundColor: Colors.white, //font color, icon color in button
// //         activeBackgroundColor:
// //             Colors.deepPurpleAccent, //background color when menu is expanded
// //         activeForegroundColor: Colors.white,
// //         visible: true,
// //         closeManually: false,
// //         curve: Curves.bounceIn,
// //         overlayColor: Colors.black,
// //         overlayOpacity: 0.5,
// //         buttonSize: const Size(56.0, 56.0),
// //         children: [
// //           SpeedDialChild(
// //             //speed dial child
// //             child: const Icon(Icons.video_call),
// //             backgroundColor: Colors.red,
// //             foregroundColor: Colors.white,
// //             label: 'Yolo on Frame',
// //             labelStyle: const TextStyle(fontSize: 18.0),
// //             onTap: () {
// //               setState(() {
// //                 option = Options.frame;
// //               });
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget task(Options option) {
// //     if (option == Options.frame) {
// //       return YoloVideo(vision: vision);
// //     }
// //     return const Center(child: Text("Choose Task"));
// //   }
// // }

// // class YoloVideo extends StatefulWidget {
// //   final FlutterVision vision;
// //   const YoloVideo({Key? key, required this.vision}) : super(key: key);

// //   @override
// //   State<YoloVideo> createState() => _YoloVideoState();
// // }

// // class _YoloVideoState extends State<YoloVideo> {
// //   late CameraController controller;
// //   late List<Map<String, dynamic>> yoloResults;
// //   CameraImage? cameraImage;
// //   bool isLoaded = false;
// //   bool isDetecting = false;
// //   bool isEvaluating = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     init();
// //   }

// //   init() async {
// //     cameras = await availableCameras();
// //     controller = CameraController(cameras[0], ResolutionPreset.low);
// //     controller.initialize().then((value) {
// //       loadYoloModel().then((value) {
// //         setState(() {
// //           isLoaded = true;
// //           isDetecting = false;
// //           yoloResults = [];
// //         });
// //       });
// //     });
// //   }

// //   @override
// //   void dispose() async {
// //     super.dispose();
// //     controller.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final Size size = MediaQuery.of(context).size;
// //     if (!isLoaded) {
// //       return const Scaffold(
// //         body: Center(
// //           child: Text("Model not loaded, waiting for it"),
// //         ),
// //       );
// //     }
// //     return Stack(
// //       fit: StackFit.expand,
// //       children: [
// //         AspectRatio(
// //           aspectRatio: controller.value.aspectRatio,
// //           child: CameraPreview(
// //             controller,
// //           ),
// //         ),
// //         ...displayBoxesAroundRecognizedObjects(size),
// //         Positioned(
// //           bottom: 75,
// //           width: MediaQuery.of(context).size.width,
// //           child: Container(
// //             height: 80,
// //             width: 80,
// //             decoration: BoxDecoration(
// //               shape: BoxShape.circle,
// //               border: Border.all(
// //                   width: 5, color: Colors.white, style: BorderStyle.solid),
// //             ),
// //             child: isDetecting
// //                 ? IconButton(
// //                     onPressed: () async {
// //                       stopDetection();
// //                     },
// //                     icon: const Icon(
// //                       Icons.stop,
// //                       color: Colors.red,
// //                     ),
// //                     iconSize: 50,
// //                   )
// //                 : IconButton(
// //                     onPressed: () async {
// //                       await startDetection();
// //                     },
// //                     icon: const Icon(
// //                       Icons.play_arrow,
// //                       color: Colors.white,
// //                     ),
// //                     iconSize: 50,
// //                   ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Future<void> loadYoloModel() async {
// //     try {
// //       await widget.vision.loadYoloModel(
// //           labels: 'assets/labels.txt',
// //           modelPath: 'assets/yolov8n.tflite',
// //           modelVersion: "yolov8",
// //           numThreads: 2,
// //           useGpu: false);
// //       setState(() {
// //         isLoaded = true;
// //       });
// //     } catch (e) {
// //       print(e);
// //     }
// //   }

// //   Future<void> yoloOnFrame(CameraImage cameraImage) async {
// //     try {
// //       var url = Uri.parse('http://b8f6-35-237-40-195.ngrok.io/upload');
// //       var request = http.MultipartRequest("POST", url);

// //       List<int> bytes = cameraImage.planes.fold<List<int>>(
// //         <int>[],
// //         (buffer, plane) => buffer..addAll(plane.bytes),
// //       );
// //       int height = cameraImage.height;
// //       int width = cameraImage.width;
// //       print(bytes.length);

// //       var file = http.MultipartFile.fromBytes("image", bytes,
// //           filename: 'filename.jpg');
// //       request.files.add(file);

// //       request.fields['width'] = width.toString();
// //       request.fields['height'] = height.toString();
// //       var response = await request.send();
// //       print("Response :");
// //       print(response);
// //       var result = await response.stream.bytesToString();
// //       if (response.statusCode == 200) {
// //         print("----------------------------------");
// //         print("recognitions: $result");
// //         print("----------------------------------");
// //       } else {
// //         print('Failed to send frame to API: ${response.statusCode} $result');
// //         setState(() {
// //           isEvaluating = false;
// //         });
// //       }
// //     } catch (e) {
// //       print("Error running model: $e");
// //     }
// //   }
// //   // setState(() {
// //   // yoloResults = result;
// //   // });
// //   // final result = await widget.vision.yoloOnFrame(
// //   //     bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
// //   //     imageHeight: cameraImage.height,
// //   //     imageWidth: cameraImage.width,
// //   //     iouThreshold: 0.4,
// //   //     confThreshold: 0.4,
// //   //     classThreshold: 0.5);
// //   // if (result.isNotEmpty) {
// //   //   setState(() {
// //   //     yoloResults = result;
// //   //   });
// //   // }
// // // setState(() {
// // //       isEvaluating = false;
// // //     });

// //   Future<void> startDetection() async {
// //     setState(() {
// //       isDetecting = true;
// //     });
// //     if (controller.value.isStreamingImages) {
// //       return;
// //     }
// //     await controller.startImageStream((image) async {
// //       cameraImage = image;
// //       if (isDetecting && !isEvaluating) {
// //         setState(() {
// //           isEvaluating = true; // Mark as currently evaluating
// //         });
// //         yoloOnFrame(image);
// //       }
// //     });
// //   }

// //   Future<void> stopDetection() async {
// //     setState(() {
// //       isDetecting = false;
// //       yoloResults.clear();
// //     });
// //   }

// //   List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
// //     if (yoloResults.isEmpty) return [];

// //     double factorX = screen.width;
// //     double factorY = screen.height;

// //     Color colorPick = const Color.fromARGB(255, 50, 233, 30);

// //     return yoloResults.map((result) {
// //       List<dynamic> box = result["box"];
// //       double x = box[0];
// //       double y = box[1];
// //       double width = box[2] - box[0];
// //       double height = box[3] - box[1];
// //       double confidence = box[4];

// //       return Positioned(
// //         left: x * factorX,
// //         top: y * factorY,
// //         width: width * factorX,
// //         height: height * factorY,
// //         child: Container(
// //           decoration: BoxDecoration(
// //             borderRadius: const BorderRadius.all(Radius.circular(10.0)),
// //             border: Border.all(color: Colors.pink, width: 2.0),
// //           ),
// //           child: Text(
// //             "${result['tag']} ${(confidence * 100).toStringAsFixed(0)}%",
// //             style: TextStyle(
// //               background: Paint()..color = colorPick,
// //               color: Colors.white,
// //               fontSize: 18.0,
// //             ),
// //           ),
// //         ),
// //       );
// //     }).toList();
// //   }
// // }







// #Center wala case
// import json
// import cv2
// import time
// from ultralytics import YOLO
// from IPython.display import display, clear_output
// from PIL import Image, ImageDraw
// from google.colab.patches import cv2_imshow
// import IPython.display as ipd
// import numpy as np
// from flask import Flask, request, jsonify
// from flask_ngrok import run_with_ngrok
// import base64
// import os
// import traceback

// # Initialize YOLO model
// model = YOLO("yolov8m.pt")
// object_id_to_name = {
//     0: 'فرد', 1: 'سائیکل', 2: 'گاڑی', 3: 'موٹرسائیکل', 4: 'ہوائی جہاز', 5: 'بس', 6: 'ٹرین', 7: 'ٹرک', 8: 'کشتی',
//     9: 'ٹریفک لائٹ', 10: 'فائر ہائیڈرینٹ', 11: 'اسٹاپ سائن', 12: 'پارکنگ میٹر', 13: 'بینچ', 14: 'پرندہ',
//     15: 'بلی', 16: 'کتا', 17: 'گھوڑا', 18: 'بھیڑ', 19: 'گائے', 20: 'ہاتھی', 21: 'ریچھ', 22: 'زیبرا', 23: 'زرافہ',
//     24: 'بیک پیک', 25: 'چھائی', 26: 'ہینڈ بیگ', 27: 'ٹائی', 28: 'سوٹ کیس', 29: 'فرسبی', 30: 'اسکی', 31: 'برف بورڈ',
//     32: 'کھیل', 33: 'پٹنگ', 34: 'بیس بال بیٹ', 35: 'بیس بال گلوو', 36: 'اسکیٹ بورڈ', 37: 'سرف بورڈ',
//     38: 'ٹینس ریکٹ', 39: 'بوتل', 40: 'شراب کی گلاس', 41: 'کپ', 42: 'کانسی', 43: 'چھری', 44: 'چمچ', 45: 'کٹورا',
//     46: 'کیلا', 47: 'سیب', 48: 'سینڈوچ', 49: 'مالٹا', 50: 'بروکلی', 51: 'گاجر', 52: 'ہوٹ ڈاگ', 53: 'پزا',
//     54: 'ڈونٹ', 55: 'کیک', 56: 'کرسی', 57: 'کاؤچ', 58: 'پلانٹ پوٹ', 59: 'بیڈ', 60: 'ڈائننگ ٹیبل',
//     61: 'ٹوائلٹ', 62: 'ٹی وی', 63: 'لیپ ٹاپ', 64: 'ماؤس', 65: 'ریموٹ', 66: 'کی بورڈ', 67: 'سیل فون',
//     68: 'مائیکروویو', 69: 'افران', 70: 'ٹوسٹر', 71: 'سنک', 72: 'ریفریجریٹر', 73: 'کتاب', 74: 'گھڑی',
//     75: 'گلدان', 76: 'قینچی', 77: 'ٹیڈی بیر', 78: 'بال کی ڈرائر', 79: 'ٹوتھ برش'
// }
// urdu_numbers_dict = {
//     1: 'ایک',
//     2: 'دو',
//     3: 'تین',
//     4: 'چار',
//     5: 'پانچ',
//     6: 'چھے',
//     7: 'سات',
//     8: 'آٹھ',
//     9: 'نو'
// }

// ColisionHeight = 0.20
// ClosenessHeight = 0.34
// CenterThreshold = 0.12
// MinDistanceThreshold = 2
// dict = {}
// dict["last"] = ""
// dict["choice"] = -1
// LeftDict = {}
// RightDict = {}
// SlowDict = {}
// StopDict = {}

// def object_distance(w, h):
//   return ((2 * 3.14 * 180) / (w + h * 360) * 1000 + 3)
// def detection(frame, model):
//     results = model.track(frame, conf=0.3, iou=0.5)
//     shape = results[0].boxes.orig_shape
//     cls = results[0].boxes.cls
//     xywh = results[0].boxes.xywh
//     ids = results[0].boxes.id
//     result_array = [shape, cls, xywh, ids, results[0]]
//     return result_array
// def setStreight():
//   if (dict["last"] != "streight"):
//     dict["last"] = "streight"
//     return True
//   else:
//     return False
// def setSlow():
//     return True

// def setStopAndCompleteTurn():
//     return True

// def setStopLeft():
//     return True

// def setStopRight():
//     return True

// def extractClasses(ids, classes, filtered_listC):
//   class_name = ""
//   if len(filtered_listC) == 1:
//     class_name = object_id_to_name[int(classes[filtered_listC[0]])]
//   else:
//     for i, dis in enumerate(filtered_listC):
//       class_name += object_id_to_name[int(classes[dis])]
//       class_name += " "
//       class_name += urdu_numbers_dict[int(ids[dis])]
//       if i != len(filtered_listC)-1:
//         class_name += " , "
//   return class_name

// def clearRepeatClasses(ids, filtered_listC, tempDict, ax):
//   tempL = []
//   for i, dis in enumerate(filtered_listC):
//       if int(ids[dis]) in tempDict:
//         pass
//       else:
//         tempDict[int(ids[dis])] = ax
//         tempL.append(dis)
//   # Remove keys from tempDict that are not present in the ids list
//   keys_to_remove = [key for key in tempDict if key not in ids]
//   for key in keys_to_remove:
//       del tempDict[key]
//   return tempL


// def setChoice(ch):
//   if (ch == 3 and dict['choice'] == 4) or (ch == 4 and dict['choice'] == 3):
//     dict['choice'] = 2
//   elif dict['choice'] == 1 and ch > dict['choice']:
//     dict['choice'] = ch
//   elif dict['choice'] == -1:
//     dict['choice'] = ch

// def checkColision(imageB, objB):
//   closenessLvl = imageB[0] * ClosenessHeight
//   colisionLvl = imageB[0] * ColisionHeight
//   centerLvl = imageB[1] * CenterThreshold
//   print(imageB, colisionLvl, closenessLvl, centerLvl)
//   imageW, imageH = imageB[1], imageB[0]
//   left = int(objB[0] - objB[2] / 2)
//   right = int(objB[0] + objB[2] / 2)
//   top = int(objB[1] - objB[3] / 2)
//   bottom = int(objB[1] + objB[3] / 2)

//   centerLeft, centerRight = [imageW/2 - centerLvl, imageW/2 + centerLvl]
//   if (not (left<centerLeft and right<centerLeft) and not (left>centerRight and right>centerRight)):
//     if bottom > imageH - colisionLvl and (left < centerRight or right > centerLeft): #check colision
//       if left < centerLeft and right > centerRight:
//         setChoice(2)
//       elif left < centerLeft:
//         setChoice(3)
//       elif right > centerRight:
//         setChoice(4)
//       return True
//     elif bottom > imageH - closenessLvl and bottom < imageH - colisionLvl and (left < centerRight or right > centerLeft): #check closeness
//       setChoice(1)
//       return True
//     else:
//       setChoice(0)
//       return False
//   setChoice(0)
//   return False

// def guide_user(frame, model):
//     shape, classes, boxes, ids, result = detection(frame, model)
//     all_boxes_distance_list = []
//     message = ""
//     detection_list = []

//     centerLeft_x_int = int(shape[1] / 2 - shape[1] * CenterThreshold)
//     centerRight_x_int = int(shape[1] / 2 + shape[1] * CenterThreshold)
//     cv2.line(frame, (centerLeft_x_int, 0), (centerLeft_x_int, shape[0]), (255, 0, 255), 2)
//     cv2.line(frame, (centerRight_x_int, 0), (centerRight_x_int, shape[0]), (255, 0, 255), 2)
//     colisionLvl = int(shape[0] * ColisionHeight)
//     closenessLvl = int(shape[0] * ClosenessHeight)

//     cv2.line(frame, (0, shape[0] - colisionLvl), (shape[1], shape[0] - colisionLvl), (0, 0, 255), 2)
//     cv2.line(frame, (0, shape[0] - closenessLvl), (shape[1], shape[0] - closenessLvl), (0, 255, 0), 2)

//     display_frame(result)

//     dict["choice"] == 0
//     if ids is not None:
//       for i, x in enumerate(classes):
//        class_id = int(x)
//        detection_list.append(f"Id: {int(ids[i])} {object_id_to_name[class_id]}")
//       for i, obj in enumerate(boxes):
//         w, h = obj[2], obj[3]
//         distancei = object_distance(w, h)
//         all_boxes_distance_list.append(distancei)
//       min_distance = min(all_boxes_distance_list)

//       #                         check agar 1 ya 1 se zyada cheezon se takranye lagye hain to
//       collision = False
//       filtered_listD = [num for num in all_boxes_distance_list if num <= min_distance + MinDistanceThreshold]
//       filtered_listC = []
//       for dis in filtered_listD:
//         tempList = [index for index, value in enumerate(all_boxes_distance_list) if value == dis]
//         cols = checkColision(shape, boxes[all_boxes_distance_list.index(dis)])
//         if cols:
//           collision = True
//           filtered_listC.extend(tempList)

//     # no hurdle wala case
//     if dict["choice"] == 0:
//       if setStreight():
//         message = f"سیدھے چلتے جائیں"
//         time.sleep(0.3)
//       else:
//         temp = {}
//         temp["left"] = []
//         temp["right"] = []
//         for dis in filtered_listD:
//           x = all_boxes_distance_list.index(dis)
//           if int(ids[x]) in dict:
//             dict[int(ids[x])] += 1
//           else:
//             dict[int(ids[x])] = 1
//             if boxes[x][0] < shape[1] // 2:
//                     temp["left"].append(x)
//             elif boxes[x][0] > shape[1] // 2:
//                     temp["right"].append(x)
//         temp["left"] = clearRepeatClasses(ids, filtered_listC, LeftDict, 0)
//         temp["right"] = clearRepeatClasses(ids, filtered_listC, RightDict, 0)
//         if temp["left"] != [] and temp["right"] != []:
//           left_objects = extractClasses(ids, classes, temp["left"])
//           right_objects = extractClasses(ids, classes, temp["right"])
//           message = f"آپ بائیں جانب {left_objects} اور دائیں جانب {right_objects} کے قریب جا رہے ہیں"
//         elif temp["left"] != []:
//           left_objects = extractClasses(ids, classes, temp["left"])
//           message = f"آپ بائیں جانب {left_objects} کے قریب جا رہے ہیں"
//         elif temp["right"] != []:
//           right_objects = extractClasses(ids, classes, temp["right"])
//           message = f"آپ دائیں جانب {right_objects} کے قریب جا رہے ہیں"
//     # near wala case
//     elif dict["choice"] == 1 :
//       if setSlow():
//         filtered_listC = clearRepeatClasses(ids, filtered_listC, SlowDict, 1)
//         if filtered_listC != [] :
//           class_name = extractClasses(ids, classes, filtered_listC)
//           message = f"آگے {class_name} سے بچنے کے لئے آہستہ چلیں"
//       dict["choice"] = -1
//     # stop And Complete Turn wala case
//     elif dict["choice"] == 2:
//       if setStopAndCompleteTurn():
//         filtered_listC = clearRepeatClasses(ids, filtered_listC, StopDict, 2)
//         if filtered_listC != [] :
//             class_name = class_name = extractClasses(ids, classes, filtered_listC)
//             message = f"رک جائیں {class_name} سے بچنے کے لئے بائیں جانب جائیں  "
//       dict["choice"] = -1
//     # stop And Right Turn wala case
//     elif dict["choice"] == 3:
//       if setStopLeft():
//         filtered_listC = clearRepeatClasses(ids, filtered_listC, StopDict, 2)
//         if filtered_listC != [] :
//           class_name = class_name = extractClasses(ids, classes, filtered_listC)
//           message = f"رک جائیں {class_name} سے بچنے کے لئے تھوڑا دائیں جانب ہو جائیں  "
//       dict["choice"] = -1
//     # stop And Left Turn wala case
//     elif dict["choice"] == 4:
//       if setStopRight():
//         filtered_listC = clearRepeatClasses(ids, filtered_listC, StopDict, 2)
//         if filtered_listC != [] :
//           class_name = class_name = extractClasses(ids, classes, filtered_listC)
//           message = f"رک جائیں {class_name} سے بچنے کے لئے تھوڑا بائیں جانب ہو جائیں  "
//       dict["choice"] = -1

//     response = {
//           'speech': message,
//           'boxes': boxes.tolist(),
//           'names': detection_list
//       }
//     return response
// def display_frame(result):
//     annotated_frame = result.plot()
//     cv2_imshow(annotated_frame)



// app = Flask(__name__)
// run_with_ngrok(app)

// @app.route('/uploadByGallery', methods=['POST'])
// def uploadByGallery():
//     try:
//         if 'image' not in request.files:
//             return jsonify({'error': 'No image file provided'}), 400

//         image = request.files['image']
//         if image.filename == '':
//             return jsonify({'error': 'No selected file'}), 400

//         if image:
//             image_bytes = image.read()
//             image_np = np.frombuffer(image_bytes, np.uint8)
//             img = cv2.imdecode(image_np, cv2.IMREAD_COLOR)
//             response = guide_user(img, model)
//             print(response)
//             return jsonify(response), 200
//     except Exception as e:
//         return jsonify({'error': str(e)}), 500


// @app.route('/upload', methods=['POST'])
// def upload():
//     try:
//       base64_image = request.form.get('image')
//       image_data = base64.b64decode(base64_image)
//       nparr = np.frombuffer(image_data, np.uint8)
//       image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
//       rotated_image = cv2.rotate(image, cv2.ROTATE_90_CLOCKWISE)

//       # Call the guide_user function with the rotated image
//       response = guide_user(rotated_image, model)
//       print(response)

//       return jsonify(response), 200

//     except Exception as e:
//         traceback.print_exc()
//         return jsonify({'error': 'An error occurred'}), 500

// @app.route('/', methods=['POST'])
// def hello_world():
//     print('Hello World')
//     return jsonify({'width': '10'}), 200

// if __name__ == '__main__':
//     app.run()
