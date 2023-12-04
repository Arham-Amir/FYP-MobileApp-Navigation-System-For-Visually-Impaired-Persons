// // ignore_for_file: library_private_types_in_public_api
// import 'package:beyond_vis/views/camera_view.dart';
// import 'package:flutter/material.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(home: CameraView());
//   }
// }

// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'dart:async';
// import 'package:flutter_vision/flutter_vision.dart';
// import 'package:flutter_tflite/flutter_tflite.dart';
// import 'package:image_picker/image_picker.dart';

// enum Options { none, imagev5, imagev8, imagev8seg, frame, tesseract, vision }

// late List<CameraDescription> cameras;
// main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//   runApp(
//     const MaterialApp(
//       home: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late FlutterVision vision;
//   Options option = Options.none;
//   @override
//   void initState() {
//     super.initState();
//     // vision = FlutterVision();
//   }

//   @override
//   void dispose() async {
//     super.dispose();
//     // await vision.closeTesseractModel();
//     // await vision.closeYoloModel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: task(option),
//       floatingActionButton: SpeedDial(
//         //margin bottom
//         icon: Icons.menu, //icon on Floating action button
//         activeIcon: Icons.close, //icon when menu is expanded on button
//         backgroundColor: Colors.black12, //background color of button
//         foregroundColor: Colors.white, //font color, icon color in button
//         activeBackgroundColor:
//             Colors.deepPurpleAccent, //background color when menu is expanded
//         activeForegroundColor: Colors.white,
//         visible: true,
//         closeManually: false,
//         curve: Curves.bounceIn,
//         overlayColor: Colors.black,
//         overlayOpacity: 0.5,
//         buttonSize: const Size(56.0, 56.0),
//         children: [
//           SpeedDialChild(
//             //speed dial child
//             child: const Icon(Icons.video_call),
//             backgroundColor: Colors.red,
//             foregroundColor: Colors.white,
//             label: 'Yolo on Frame',
//             labelStyle: const TextStyle(fontSize: 18.0),
//             onTap: () {
//               setState(() {
//                 option = Options.frame;
//               });
//             },
//           )
//           // SpeedDialChild(
//           //   child: const Icon(Icons.document_scanner),
//           //   foregroundColor: Colors.white,
//           //   backgroundColor: Colors.green,
//           //   label: 'Vision',
//           //   labelStyle: const TextStyle(fontSize: 18.0),
//           //   onTap: () {
//           //     setState(() {
//           //       option = Options.vision;
//           //     });
//           //   },
//           // ),
//         ],
//       ),
//     );
//   }

//   Widget task(Options option) {
//     if (option == Options.frame) {
//       return YoloVideo();
//     }
//     return const Center(child: Text("Choose Task"));
//   }
// }

// class YoloVideo extends StatefulWidget {
//   const YoloVideo({Key? key}) : super(key: key);

//   @override
//   State<YoloVideo> createState() => _YoloVideoState();
// }

// class _YoloVideoState extends State<YoloVideo> {
//   late CameraController controller;
//   late List<Map<String, dynamic>> yoloResults;
//   CameraImage? cameraImage;
//   bool isLoaded = false;
//   bool isDetecting = false;
//   bool isEvaluating = false;

//   @override
//   void initState() {
//     super.initState();
//     init();
//   }

//   init() async {
//     cameras = await availableCameras();
//     controller = CameraController(cameras[0], ResolutionPreset.medium);
//     controller.initialize().then((value) {
//       loadYoloModel().then((value) {
//         setState(() {
//           isLoaded = true;
//           isDetecting = false;
//           yoloResults = [];
//         });
//       });
//     });
//   }

//   @override
//   void dispose() async {
//     super.dispose();
//     controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     if (!isLoaded) {
//       return const Scaffold(
//         body: Center(
//           child: Text("Model not loaded, waiting for it"),
//         ),
//       );
//     }
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         AspectRatio(
//           aspectRatio: controller.value.aspectRatio,
//           child: CameraPreview(
//             controller,
//           ),
//         ),
//         ...displayBoxesAroundRecognizedObjects(size),
//         Positioned(
//           bottom: 75,
//           width: MediaQuery.of(context).size.width,
//           child: Container(
//             height: 80,
//             width: 80,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                   width: 5, color: Colors.white, style: BorderStyle.solid),
//             ),
//             child: isDetecting
//                 ? IconButton(
//                     onPressed: () async {
//                       stopDetection();
//                     },
//                     icon: const Icon(
//                       Icons.stop,
//                       color: Colors.red,
//                     ),
//                     iconSize: 50,
//                   )
//                 : IconButton(
//                     onPressed: () async {
//                       await startDetection();
//                     },
//                     icon: const Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                     ),
//                     iconSize: 50,
//                   ),
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> loadYoloModel() async {
//     try {
//       Tflite.close();
//       String? res;
//       res = await Tflite.loadModel(
//           model: 'assets/yolov2_tiny.tflite', labels: 'assets/yolov2_tiny.txt');
//       print('loadModel: $res');
//     } on PlatformException {
//       print('Failed to load model.');
//     }
//   }

//   Future<void> yoloOnFrame(CameraImage image) async {
//     final recognitions = await Tflite.detectObjectOnFrame(
//       bytesList: image.planes.map((plane) {
//         return plane.bytes;
//       }).toList(),
//       model: "YOLO",
//       imageHeight: image.height,
//       imageWidth: image.width,
//       imageMean: 0,
//       imageStd: 255.0,
//       threshold: 0.2,
//       numResultsPerClass: 3,
//     );
//     print("----------------------------------");
//     print("recognitions: $recognitions");
//     print("----------------------------------");
//     // if (recognitions!.isNotEmpty) {
//     //   setState(() {
//     //     yoloResults = recognitions.cast<Map<String, dynamic>>();
//     //   });
//     // }
//     if (recognitions != null && recognitions.isNotEmpty) {
//       List<Map<String, dynamic>> formattedResults = recognitions.map((recog) {
//         return {
//           "tag": recog["detectedClass"],
//           "box": [
//             recog["rect"]["x"],
//             recog["rect"]["y"],
//             recog["rect"]["x"] + recog["rect"]["w"],
//             recog["rect"]["y"] + recog["rect"]["h"],
//             recog["confidenceInClass"]
//           ]
//         };
//       }).toList();
//       setState(() {
//         yoloResults = formattedResults;
//       });
//     }
//     setState(() {
//       isEvaluating = false;
//     });
//   }

//   Future<void> startDetection() async {
//     setState(() {
//       isDetecting = true;
//     });
//     if (controller.value.isStreamingImages) {
//       return;
//     }
//     await controller.startImageStream((image) async {
//       if (isDetecting && !isEvaluating) {
//         cameraImage = image;
//         try {
//           setState(() {
//             isEvaluating = true; // Mark as currently evaluating
//           });
//           yoloOnFrame(image);
//         } catch (e) {
//           print("Error running model: $e");
//           // Decide what to do: retry, show error, etc.
//         }
//       }
//     });
//   }

//   Future<void> stopDetection() async {
//     setState(() {
//       isDetecting = false;
//       yoloResults.clear();
//     });
//   }

//   List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
//     if (yoloResults.isEmpty) return [];

//     double factorX = screen.width;
//     double factorY = screen.height;

//     Color colorPick = const Color.fromARGB(255, 50, 233, 30);

//     return yoloResults.map((result) {
//       List<dynamic> box = result["box"];
//       double x = box[0];
//       double y = box[1];
//       double width = box[2] - box[0];
//       double height = box[3] - box[1];
//       double confidence = box[4];

//       return Positioned(
//         left: x * factorX,
//         top: y * factorY,
//         width: width * factorX,
//         height: height * factorY,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(10.0)),
//             border: Border.all(color: Colors.pink, width: 2.0),
//           ),
//           child: Text(
//             "${result['tag']} ${(confidence * 100).toStringAsFixed(0)}%",
//             style: TextStyle(
//               background: Paint()..color = colorPick,
//               color: Colors.white,
//               fontSize: 18.0,
//             ),
//           ),
//         ),
//       );
//     }).toList();
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as imglib;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:async';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum Options { none, imagev5, imagev8, imagev8seg, frame, tesseract, vision }

late List<CameraDescription> cameras;
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterVision vision;
  Options option = Options.none;
  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
  }

  @override
  void dispose() async {
    super.dispose();
    await vision.closeTesseractModel();
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: task(option),
      floatingActionButton: SpeedDial(
        //margin bottom
        icon: Icons.menu, //icon on Floating action button
        activeIcon: Icons.close, //icon when menu is expanded on button
        backgroundColor: Colors.black12, //background color of button
        foregroundColor: Colors.white, //font color, icon color in button
        activeBackgroundColor:
            Colors.deepPurpleAccent, //background color when menu is expanded
        activeForegroundColor: Colors.white,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        buttonSize: const Size(56.0, 56.0),
        children: [
          SpeedDialChild(
            //speed dial child
            child: const Icon(Icons.video_call),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Yolo on Frame',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                option = Options.frame;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget task(Options option) {
    if (option == Options.frame) {
      return YoloVideo(vision: vision);
    }
    return const Center(child: Text("Choose Task"));
  }
}

class YoloVideo extends StatefulWidget {
  final FlutterVision vision;
  const YoloVideo({Key? key, required this.vision}) : super(key: key);

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
  late CameraController controller;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  bool isEvaluating = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.low);
    controller.initialize().then((value) {
      loadYoloModel().then((value) {
        setState(() {
          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
        });
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(
            controller,
          ),
        ),
        ...displayBoxesAroundRecognizedObjects(size),
        Positioned(
          bottom: 75,
          width: MediaQuery.of(context).size.width,
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  width: 5, color: Colors.white, style: BorderStyle.solid),
            ),
            child: isDetecting
                ? IconButton(
                    onPressed: () async {
                      stopDetection();
                    },
                    icon: const Icon(
                      Icons.stop,
                      color: Colors.red,
                    ),
                    iconSize: 50,
                  )
                : IconButton(
                    onPressed: () async {
                      await startDetection();
                    },
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    iconSize: 50,
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> loadYoloModel() async {
    try {
      await widget.vision.loadYoloModel(
          labels: 'assets/labels.txt',
          modelPath: 'assets/yolov8n.tflite',
          modelVersion: "yolov8",
          numThreads: 2,
          useGpu: false);
      setState(() {
        isLoaded = true;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    try {
      var url = Uri.parse('http://b8f6-35-237-40-195.ngrok.io/upload');
      var request = http.MultipartRequest("POST", url);

      List<int> bytes = cameraImage.planes.fold<List<int>>(
        <int>[],
        (buffer, plane) => buffer..addAll(plane.bytes),
      );
      int height = cameraImage.height;
      int width = cameraImage.width;
      print(bytes.length);

      var file = http.MultipartFile.fromBytes("image", bytes,
          filename: 'filename.jpg');
      request.files.add(file);

      request.fields['width'] = width.toString();
      request.fields['height'] = height.toString();
      var response = await request.send();
      print("Response :");
      print(response);
      var result = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        print("----------------------------------");
        print("recognitions: $result");
        print("----------------------------------");
      } else {
        print('Failed to send frame to API: ${response.statusCode} $result');
        setState(() {
          isEvaluating = false;
        });
      }
    } catch (e) {
      print("Error running model: $e");
    }
  }
  // setState(() {
  // yoloResults = result;
  // });
  // final result = await widget.vision.yoloOnFrame(
  //     bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
  //     imageHeight: cameraImage.height,
  //     imageWidth: cameraImage.width,
  //     iouThreshold: 0.4,
  //     confThreshold: 0.4,
  //     classThreshold: 0.5);
  // if (result.isNotEmpty) {
  //   setState(() {
  //     yoloResults = result;
  //   });
  // }
// setState(() {
//       isEvaluating = false;
//     });

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      cameraImage = image;
      if (isDetecting && !isEvaluating) {
        setState(() {
          isEvaluating = true; // Mark as currently evaluating
        });
        yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];

    double factorX = screen.width;
    double factorY = screen.height;

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return yoloResults.map((result) {
      List<dynamic> box = result["box"];
      double x = box[0];
      double y = box[1];
      double width = box[2] - box[0];
      double height = box[3] - box[1];
      double confidence = box[4];

      return Positioned(
        left: x * factorX,
        top: y * factorY,
        width: width * factorX,
        height: height * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(confidence * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}
