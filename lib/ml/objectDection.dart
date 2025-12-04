import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ObjectDetectionScreen extends StatefulWidget {
  //final List<CameraDescription> cameras;
  const ObjectDetectionScreen({Key? key})
      : super(key: key);

  @override
  _ObjectDetectionScreenState createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  late CameraController controller;
  late ObjectDetector objectDetector;

  bool isBusy = false;
  CameraImage? img;
  List<DetectedObject> objects = [];
  late List<CameraDescription> cameras;

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
    final options = ObjectDetectorOptions(
      mode: DetectionMode.stream,
      classifyObjects: true,
      multipleObjects: true,
    );
    objectDetector = ObjectDetector(options: options);
    //initializeCamera();

  }
  Future<void> _loadCameras() async {
    cameras = await availableCameras();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    controller = CameraController(
      cameras[0], // BACK CAMERA
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup:
      Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );

    await controller.initialize();

    controller.startImageStream((image) async {
      if (!isBusy) {
        isBusy = true;
        img = image;
        await detectObjects();
      }
    });

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    try {
      controller.stopImageStream();
    } catch (_) {}

    controller.dispose();
    objectDetector.close();
    super.dispose();
  }

  // ------------------------------
  // REAL TIME OBJECT DETECTION
  // ------------------------------
  Future<void> detectObjects() async {
    if (!mounted) return;

    final inputImage = getInputImage();
    if (inputImage == null) {
      isBusy = false;
      return;
    }

    try {
      final detected = await objectDetector.processImage(inputImage);// to put image into the Object model

      if (mounted) {
        setState(() {
          objects = detected;
        });
      }
    } catch (e) {}

    isBusy = false;
  }

  // -------------------------------------------
  // CONVERT CAMERA → INPUT IMAGE
  // -------------------------------------------
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
    if (format == null) return null;

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
  // UI WITH CUSTOM PAINTER
  // ------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Object Detection"),
      ),
      body: controller.value.isInitialized
          ? Stack(
        children: [
          Positioned.fill(child: CameraPreview(controller)),

          Positioned.fill(
            child: CustomPaint(
              painter: ObjectPainter(
                objects: objects,
                previewSize: controller.value.previewSize!,
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

// ------------------------------------------------------
//                CUSTOM PAINTER FOR OBJECTS
// ------------------------------------------------------
class ObjectPainter extends CustomPainter {
  final List<DetectedObject> objects;
  final Size previewSize;

  ObjectPainter({
    required this.objects,
    required this.previewSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / previewSize.height;
    final double scaleY = size.height / previewSize.width;

    final Paint boxPaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (final obj in objects) {
      final rect = Rect.fromLTRB(
        obj.boundingBox.left * scaleX,
        obj.boundingBox.top * scaleY,
        obj.boundingBox.right * scaleX,
        obj.boundingBox.bottom * scaleY,
      );

      // Draw bounding box
      canvas.drawRect(rect, boxPaint);

      // Prepare label
      if (obj.labels.isNotEmpty) {
        final label = obj.labels.first;
        final title =
            "${label.text} ${(label.confidence * 100).toStringAsFixed(1)}%";

        // Draw label background
        final labelBg = Paint()..color = Colors.black87;

        const padding = 4;
        final textSpan = TextSpan(
          text: title,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        );
        final tp = TextPainter(
          text: textSpan,
          maxLines: 1,
          textDirection: TextDirection.ltr,
        );

        tp.layout();

        final bgRect = Rect.fromLTWH(
          rect.left,
          rect.top - tp.height - 8,
          tp.width + 8,
          tp.height + 4,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(bgRect, const Radius.circular(4)),
          labelBg,
        );

        tp.paint(
          canvas,
          Offset(rect.left + padding, rect.top - tp.height - 6),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ObjectPainter oldDelegate) =>
      oldDelegate.objects != objects;
}
