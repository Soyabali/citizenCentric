
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';


class TextRecognitionScreen extends StatefulWidget {

  //final List<CameraDescription> cameras;
  const TextRecognitionScreen({Key? key})
      : super(key: key);

  @override
  _TextRecognitionScreenState createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {

  late CameraController controller;
  late TextRecognizer textRecognizer;
  late List<CameraDescription> cameras;

  bool isBusy = false;
  CameraImage? img;
  RecognizedText? recognizedText;

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void initState() {
    super.initState();
    textRecognizer = TextRecognizer();
   /// initializeCamera();
    _loadCameras();
  }
  Future<void> _loadCameras() async {
    cameras = await availableCameras();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    // Initialize BACK Camera
    controller = CameraController(
      cameras[0],// back camra
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
        await doTextRecognition();
      }
    });

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    textRecognizer.close();
    super.dispose();
  }

  // ------------------------------
  // REAL TIME TEXT RECOGNITION
  // ------------------------------
  Future<void> doTextRecognition() async {
    final inputImage = getInputImage();
    if (inputImage == null) {
      isBusy = false;
      return;
    }

    final text = await textRecognizer.processImage(inputImage);// here you give the image textRecognize model.

    setState(() {
      recognizedText = text;
    });

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
  // UI + CAMERA PREVIEW + RESULTS
  // ------------------------------
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Real-Time Text Recognition"),
      ),
      body: controller.value.isInitialized
          ? Stack(
        children: [
          // CAMERA
          Positioned.fill(
            child: CameraPreview(controller),
          ),

          // TEXT RESULT BOX
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
              child: Text(
                recognizedText?.text ?? "Scanning...",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
