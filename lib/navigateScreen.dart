// ignore_for_file: file_names

import 'package:beyond_vis/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as imglib;
import 'dart:convert';
import 'helper.dart';

class YoloVideo extends StatefulWidget {
  const YoloVideo({super.key});

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
  Helper helper = Helper();
  late CameraController controller;
  List<dynamic> resultBoxes = [];
  List<String> resultNames = [];
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  bool isEvaluating = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void listenForCommands() {
    helper.startListening((command) {
      processCommand(command);
    });
  }

  void processCommand(String command) {
    print(">>>>>>>>> $command");
    if (command.toLowerCase().contains('navigate me')) {
      startDetection();
    } else if (command.toLowerCase().contains('back to home')) {
      Navigator.popUntil(
          context, ModalRoute.withName(Navigator.defaultRouteName));
    }
  }

  init() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((value) {
      setState(() {
        isLoaded = true;
        isDetecting = false;
        resultBoxes = [];
        resultNames = [];
      });
      listenForCommands();
    });
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    helper.stopListening();
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
    return Scaffold(
        body: Stack(
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
          top: 45,
          left: 15,
          child: GestureDetector(
            onTap: backButtonPress,
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
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
    ));
  }

  void backButtonPress() async {
    final url = Uri.parse('http://cd55-34-31-157-144.ngrok-free.app/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('HTTP Request Successful');
    } else {
      print('HTTP Request Failed');
    }
    Navigator.of(context).pop();
  }

  String decodeUnicodeEscape(String text) {
    return text.replaceAllMapped(RegExp(r'\\u(\w{4})'), (match) {
      return String.fromCharCode(int.parse(match.group(1)!, radix: 16));
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    try {
      final Size size = MediaQuery.of(context).size;
      print(cameraImage.width);
      print(cameraImage.height);
      print(size.width);
      print(size.height);
      print(">>>>>>>>>");
      var url = Uri.parse('http://cd55-34-31-157-144.ngrok-free.app/upload');
      var request = http.MultipartRequest("POST", url);

      // Convert the YUV420 image to PNG bytes
      List<int> pngBytes = await convertYUV420toImageColor(cameraImage);

      // Encode the PNG bytes to Base64
      String base64Image = await convertImageToBase64(pngBytes);

      request.fields['image'] = base64Image;
      var response = await request.send();

      if (response.statusCode == 200) {
        final String responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> responseData = json.decode(responseBody);

        String speech = responseData['speech'];
        speech = decodeUnicodeEscape(speech);
        print(speech);
        List<dynamic> boxes = responseData['boxes'];
        List<String> names = responseData['names'].cast<String>();

        setState(() {
          resultBoxes = boxes.map((box) {
            return List<double>.from(box.cast<double>());
          }).toList();
          resultNames = names;
        });
        print("----------------------------------");
        print("recognitions: $responseData");
        print("----------------------------------");
        await helper.speak(speech);
        setState(() {
          isEvaluating = false;
        });
      } else {
        print('Failed to send frame to API: $response');
      }
    } catch (e) {
      print("Error running model: $e");
    }
  }

  Future<List<int>> convertYUV420toImageColor(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int? uvPixelStride = image.planes[1].bytesPerPixel;

      var img = imglib.Image.rgb(width, height);

      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          final int uvIndex =
              uvPixelStride! * (x / 2).floor() + uvRowStride * (y / 2).floor();
          final int index = y * width + x;

          final yp = image.planes[0].bytes[index];
          final up = image.planes[1].bytes[uvIndex];
          final vp = image.planes[2].bytes[uvIndex];

          int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
          int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

          img.data![index] = imglib.getColor(r, g, b);
        }
      }

      imglib.PngEncoder pngEncoder = imglib.PngEncoder(level: 0);
      List<int> png = pngEncoder.encodeImage(img)!;
      return png;
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return [];
  }

  Future<String> convertImageToBase64(List<int> bytes) async {
    final String base64String = base64Encode(bytes);
    return base64String;
  }

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
      isEvaluating = false;
    });
    listenForCommands();
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (resultNames.isEmpty) return [];

    double factorX = screen.width;
    double factorY = screen.height;
    double widthScaleFactor = screen.width / (cameraImage?.height ?? 1);
    double heightScaleFactor = screen.height / (cameraImage?.width ?? 1);

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return resultBoxes.map((result) {
      List<double> box = result;
      double x = box[0];
      double y = box[1];
      double width = box[2];
      double height = box[3];

      // Calculate the position and size of the bounding box based on the scaling factors
      double left = (x - width / 2) * widthScaleFactor;
      double top = (y - height / 2) * heightScaleFactor;
      double boxWidth = width * widthScaleFactor;
      double boxHeight = height * heightScaleFactor;
      return Positioned(
        left: left,
        top: top,
        width: boxWidth,
        height: boxHeight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${resultNames[resultBoxes.indexOf(result)]}",
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
