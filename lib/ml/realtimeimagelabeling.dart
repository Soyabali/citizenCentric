import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class RealTimeImageLabeling extends StatefulWidget {
  const RealTimeImageLabeling({Key? key}) : super(key: key);

  @override
  State<RealTimeImageLabeling> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<RealTimeImageLabeling> {
  CameraController? controller;
  CameraImage? img;
  bool isBusy = false;
  String result = "";
  dynamic imageLabeler;
  List<CameraDescription> cameras = [];

  // --------------------------
  // RESULT UI LIST
  // --------------------------
  List<Widget> _buildResultList() {
    List<String> lines = result.trim().split("\n");

    return lines.map((line) {
      final parts = line.trim().split("   ");
      final label = parts[0];
      final conf = parts.length > 1 ? parts[1] : "";

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              conf,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // --------------------------
  // INIT STATE
  // --------------------------
  @override
  void initState() {
    super.initState();

    imageLabeler = ImageLabeler(
      options: ImageLabelerOptions(confidenceThreshold: 0.5),
    );

    _loadCameras();
  }

  // --------------------------
  // LOAD CAMERA LIST
  // --------------------------
  Future<void> _loadCameras() async {
    cameras = await availableCameras();
    initializeCamera();
  }

  // --------------------------
  // INITIALIZE CAMERA
  // --------------------------
  Future<void> initializeCamera() async {
    controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
      imageFormatGroup:
      Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );

    await controller!.initialize();

    controller!.startImageStream((image) {
      if (!isBusy) {
        isBusy = true;
        img = image;
        doImageLabeling();
      }
    });

    if (mounted) setState(() {});
  }

  // --------------------------
  // ML PROCESSING
  // --------------------------
  doImageLabeling() async {
    if (img == null) return;

    result = "";
    final inputImg = getInputImage();
    if (inputImg == null) {
      isBusy = false;
      return;
    }

    final List<ImageLabel> labels = await imageLabeler.processImage(inputImg);// to put data imageModel

    for (ImageLabel label in labels) {
      final String text = label.label;
      final double confidence = label.confidence;
      result += "$text   ${confidence.toStringAsFixed(2)}\n";
    }

    setState(() {
      isBusy = false;
    });
  }

  // --------------------------
  // ORIENTATION MAP
  // --------------------------
  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  // --------------------------
  // CONVERT FRAME => InputImage
  // --------------------------
  InputImage? getInputImage() {
    if (controller == null || img == null) return null;

    final camera = cameras[0];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else {
      var rotationCompensation =
          _orientations[controller!.value.deviceOrientation] ?? 0;

      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation =
            (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }

      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(img!.format.raw);

    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    if (img!.planes.isEmpty) return null;

    final plane = img!.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(img!.width.toDouble(), img!.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  // --------------------------
  // DISPOSE CAMERA
  // --------------------------
  @override
  void dispose() {
    controller?.dispose();
    imageLabeler.close();
    super.dispose();
  }

  // --------------------------
  // BUILD UI
  // --------------------------
  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Image Label"),
        backgroundColor: Colors.black87,
        elevation: 2,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // CAMERA
            Expanded(
              flex: 6,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: CameraPreview(controller!),
              ),
            ),

            const SizedBox(height: 10),

            // RESULT CARD
            Expanded(
              flex: 4,
              child: Card(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: result.isEmpty
                        ? const Center(
                      child: Text(
                        "Scanning...",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildResultList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class RealTimeImageLabeling extends StatefulWidget {
//   //final List<CameraDescription> cameras;
//
//   const RealTimeImageLabeling({Key? key}) : super(key: key);
//
//   @override
//   State<RealTimeImageLabeling> createState() => _CameraScreenState();
// }
//
// class _CameraScreenState extends State<RealTimeImageLabeling> {
//
//   // late CameraController controller;
//   CameraController? controller;
//   CameraImage? img;
//   bool isBusy = false;
//   String result = "";
//   dynamic imageLabeler;
//   late List<CameraDescription> cameras;
//
//   // ---function to data represents-------
//   List<Widget> _buildResultList() {
//     List<String> lines = result.trim().split("\n");
//
//     return lines.map((line) {
//       final parts = line.trim().split("   ");
//       final label = parts[0];
//       final conf = parts.length > 1 ? parts[1] : "";
//
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 6.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//             Text(
//               conf,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.deepPurple,
//               ),
//             ),
//           ],
//         ),
//       );
//     }).toList();
//   }
//   //----end the function --------
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     //TODO initialize labeler
//     final ImageLabelerOptions options = ImageLabelerOptions(
//         confidenceThreshold: 0.5);
//     imageLabeler = ImageLabeler(options: options);
//     _loadCameras();
//   }
//   // STEP 1: Load cameras inside screen
//   Future<void> _loadCameras() async {
//     cameras = await availableCameras();
//     initializeCamera();
//   }
//   // STEP 2: Initialize the camera after loading camera list
//
//   Future<void> initializeCamera() async {
//     controller = CameraController(
//       cameras[0], // 0 = back, 1 = front
//       ResolutionPreset.high,
//       imageFormatGroup: Platform.isAndroid
//           ? ImageFormatGroup.nv21
//           : ImageFormatGroup.bgra8888,
//     );
//
//     await controller?.initialize();
//
//     controller.startImageStream((image) {
//       if (!isBusy) {
//         isBusy = true;
//         img = image;
//         doImageLabeling();
//       }
//     });
//
//     if (mounted) setState(() {});
//   }
//
//   doImageLabeling() async {
//     result = "";
//     InputImage? inputImg = getInputImage();
//     final List<ImageLabel> labels = await imageLabeler.processImage(inputImg);
//     for (ImageLabel label in labels) {
//       final String text = label.label;
//       final int index = label.index;
//       final double confidence = label.confidence;
//       result += "$text   ${confidence.toStringAsFixed(2)}\n";
//       print("===--70---$result");
//     }
//     setState(() {
//       result;
//       isBusy = false;
//     });
//   }
//
//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };
//   InputImage? getInputImage() {
//     // get image rotation
//     // it is used in android to convert the InputImage from Dart to Java
//     // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
//     // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
//     //final camera = _cameras[1];
//     final camera = cameras[1];
//     final sensorOrientation = camera.sensorOrientation;
//     InputImageRotation? rotation;
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       var rotationCompensation = _orientations[controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//       if (camera.lensDirection == CameraLensDirection.front) {
//         // front-facing
//         rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
//       } else {
//         // back-facing
//         rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
//       }
//       rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
//     }
//     if (rotation == null) return null;
//     // get image format
//     final format = InputImageFormatValue.fromRawValue(img!.format.raw);
//     // validate format depending on platform
//     // only supported formats:
//     // * nv21 for Android
//     // * bgra8888 for iOS
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;
//
//     // since format is constraint to nv21 or bgra8888, both only have one plane
//     if (img?.planes.length != 1) return null;
//     final plane = img?.planes.first;
//
//     // compose InputImage using bytes
//     return InputImage.fromBytes(
//       bytes: plane!.bytes,
//       metadata: InputImageMetadata(
//         size: Size(img!.width.toDouble(),
//             img!.height.toDouble()),
//         rotation: rotation, // used only in Android
//         format: format, // used only in iOS
//         bytesPerRow: plane.bytesPerRow, // used only in iOS
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text("Image Label"),
//         backgroundColor: Colors.black87,
//         elevation: 2,
//       ),
//
//       backgroundColor: Colors.black,
//
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             // =============================
//             //  CAMERA PREVIEW (60% height)
//             // =============================
//             Expanded(
//               flex: 6, // 60%
//               child: Card(
//                 elevation: 6,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 clipBehavior: Clip.antiAlias,
//                 child: CameraPreview(controller),
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // =============================
//             //   LABEL RESULT CARD
//             // =============================
//             Expanded(
//               flex: 4, // remaining 40%
//               child: Card(
//                 color: Colors.white,
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: SingleChildScrollView(
//                     child: result.isEmpty
//                         ? const Center(
//                       child: Text(
//                         "Scanning...",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     )
//                         : Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: _buildResultList(),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

