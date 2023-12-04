import 'package:beyond_vis/controller/scan_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraView extends StatelessWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return controller.isCameraInitiallized.value
              ? Stack(
                  children: [
                    CameraPreview(controller.cameraController),
                  ],
                )
              : const Text("Loading Preview");
        },
      ),
    );
  }
}
