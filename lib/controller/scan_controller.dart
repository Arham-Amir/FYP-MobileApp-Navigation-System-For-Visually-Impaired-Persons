import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTFLite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;
  FlutterVision vision = FlutterVision();

  var cameraCount = 0;
  var isCameraInitiallized = false.obs;

  var isProcessingFrame = false.obs;

  var label = "";

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.max,
      );
      try {

      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0 && !isProcessingFrame.value) {
            cameraCount = 0;
            objectDetector(image);
            // print(image);
          }
          update();
        });
      });
      isCameraInitiallized.value = true;
      update();
      } catch (e) {
        print('Camera Initialization Error: $e');
      }
    } else {
      print("Permission Denied");
    }
  }

  initTFLite() async{
    // await Tflite.loadModel(
    //   model: "assets/yolov8n_float32.tflite",
    //   labels: "assets/labels.txt",
    //   isAsset: true,
    //   numThreads: 1,
    //   useGpuDelegate: false,
    // );
    await vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/yolov8n.tflite',
        modelVersion: "yolov8",
        quantization: false,
        numThreads: 1,
        useGpu: false);
  }

  objectDetector(CameraImage cameraImage) async {

    if(isProcessingFrame.value) return;

    isProcessingFrame.value = true;

    print("Image Taken :-");
    print(cameraImage);

    try {
      // var detector = await Tflite.detectObjectOnFrame(
      //   bytesList: image.planes.map((e) {
      //     return e.bytes;
      //   }).toList(),
      //     model: "YOLO",
      //     imageHeight: image.height,
      //     imageWidth: image.width,
      //     imageMean: 0,
      //     imageStd: 255.0,
      //     // numResults: 2,
      //     threshold: 0.1,
      //     numResultsPerClass: 2,// defaults to 5
      //     // anchors: anchors,     // defaults to [0.57273,0.677385,1.87446,2.06253,3.33843,5.47434,7.88282,3.52778,9.77052,9.16828]
      //     blockSize: 32,        // defaults to 32
      //     numBoxesPerBlock: 5,  // defaults to 5
      //     asynch: true
      // );
      final detector = await vision.yoloOnFrame(
          bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
          imageHeight: cameraImage.height,
          imageWidth: cameraImage.width,
          iouThreshold: 0.4,
          confThreshold: 0.4,
          classThreshold: 0.4);
      if (detector != null) {
        print("result is $detector");
      }
    }finally {
      isProcessingFrame.value = false;  // Reset the flag after processing
    }
  }
}
