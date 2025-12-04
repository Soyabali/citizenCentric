import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';


class FaceDetectionScreen extends StatefulWidget {

  //final List<CameraDescription> cameras;
  const FaceDetectionScreen({Key? key})
      : super(key: key);

  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  late CameraController controller;
  late FaceDetector faceDetector;
  late List<CameraDescription> cameras;

  bool isBusy = false;
  CameraImage? img;
  List<Face> faces = [];

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void initState() {
    super.initState();
    _loadCameras();

    // ML Kit Face detector settings
    final options = FaceDetectorOptions(
      enableLandmarks: true,
      enableContours: false,
      enableClassification: true, // smile probability
      enableTracking: true,
    );
    faceDetector = FaceDetector(options: options);
    initializeCamera();
  }
  Future<void> _loadCameras() async {
    cameras = await availableCameras();
    initializeCamera();
  }


  Future<void> initializeCamera() async {
    controller = CameraController(
      cameras[1], // FRONT CAMERA (better for face)
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await controller.initialize();

    controller.startImageStream((image) async {
      if (!isBusy) {
        isBusy = true;
        img = image;
        await detectFaces();
      }
    });

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    try {
      controller.stopImageStream();    // VERY IMPORTANT
    } catch (_) {}

    controller.dispose();
    faceDetector.close();
    super.dispose();
  }

  // ------------------------------
  // REAL TIME FACE DETECTION
  // ------------------------------
  Future<void> detectFaces() async {
    if (!mounted) return;                               // screen closed? exit

    final inputImage = getInputImage(); // this is a prompt or data that is given
    if (inputImage == null) {
      isBusy = false;
      return;
    }

    try {
      // here we are giveing data (image) to a faceDector model
      final List<Face> detectedFaces = await faceDetector.processImage(inputImage);

      if (!mounted) return;                              // screen closed? exit

      setState(() {
        faces = detectedFaces;
      });
    } catch (e) {
      // If detector closed, ignore
    }

    isBusy = false;
  }

  // ------------------------------
  // CONVERT CameraImage → InputImage
  // ------------------------------
  InputImage? getInputImage() {
    if (img == null) return null;

    final camera = controller.description;
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else {
      final deviceOrientation = controller.value.deviceOrientation;
      var rotationCompensation = _orientations[deviceOrientation];
      if (rotationCompensation == null) return null;

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
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

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

  // ------------------------------
  // UI + CAMERA PREVIEW + FACE INFO BOX
  // ------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Real-Time Face Detection"),
      ),
      body: controller.value.isInitialized
          ? Stack(
        children: [
          Positioned.fill(
            child: CameraPreview(controller),
          ),

          // FACE RESULT BOX
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: faces.isEmpty
                  ? const Text(
                "No Face Detected",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Faces: ${faces.length}",
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  ...faces.map((face) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Smile: ${face.smilingProbability?.toStringAsFixed(2) ?? "N/A"}\n"
                            "Head Tilt X: ${face.headEulerAngleX?.toStringAsFixed(2)}°\n"
                            "Head Tilt Y: ${face.headEulerAngleY?.toStringAsFixed(2)}°\n"
                            "Head Tilt Z: ${face.headEulerAngleZ?.toStringAsFixed(2)}°",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
