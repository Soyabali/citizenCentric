import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectionScreen extends StatefulWidget {

  const PoseDetectionScreen({super.key});

  @override
  State<PoseDetectionScreen> createState() => _PoseDetectionScreenState();
}

class _PoseDetectionScreenState extends State<PoseDetectionScreen> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];

  CameraImage? _currentImage;
  bool isBusy = false;

  late PoseDetector _poseDetector;
  List<Pose> _poses = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    _cameras = await availableCameras();

    final options = PoseDetectorOptions(
      mode: PoseDetectionMode.stream, // IMPORTANT
    );
    _poseDetector = PoseDetector(options: options);

    await initCamera();
  }

  Future<void> initCamera() async {
    _cameraController = CameraController(
      _cameras.first,
      ResolutionPreset.high,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888, // FIXED
    );

    await _cameraController!.initialize();

    _cameraController!.startImageStream((image) {
      if (!isBusy) {
        isBusy = true;
        _currentImage = image;
        processFrame();
      }
    });

    setState(() {});
  }

  Future<void> processFrame() async {
    if (_currentImage == null) return;

    final inputImage = convertToInputImage(_currentImage!, _cameras.first);
    if (inputImage == null) {
      isBusy = false;
      return;
    }

    final poses = await _poseDetector.processImage(inputImage);

    if (mounted) {
      setState(() {
        _poses = poses;
      });
    }

    isBusy = false;
  }

  InputImage? convertToInputImage(CameraImage image, CameraDescription camera) {
    final sensorOrientation = camera.sensorOrientation;
    final rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    // Android NV21 = plane[0] contains Y buffer; iOS BGRA = plane[0].bytesPerRow used
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(
          image.width.toDouble(),
          image.height.toDouble(),
        ),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pose Detection",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_cameraController!),

          // POSE DRAWING
          CustomPaint(
            painter: PosePainter(
              cameraPreviewSize: Size(
                _cameraController!.value.previewSize!.height,
                _cameraController!.value.previewSize!.width,
              ),
              poses: _poses,
            ),
          )
        ],
      ),
    );
  }
}

// --------------------- PAINTING PART ----------------------

class PosePainter extends CustomPainter {
  final Size cameraPreviewSize;
  final List<Pose> poses;

  PosePainter({
    required this.cameraPreviewSize,
    required this.poses,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (poses.isEmpty) return;

    final double scaleX = size.width / cameraPreviewSize.width;
    final double scaleY = size.height / cameraPreviewSize.height;

    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 6
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (final pose in poses) {
      // Draw Points
      for (var landmark in pose.landmarks.values) {
        canvas.drawCircle(
          Offset(
            landmark.x * scaleX,
            landmark.y * scaleY,
          ),
          5,
          paint,
        );
      }

      // Draw sample skeleton lines (shoulders - elbows - wrists)
      drawLine(pose, PoseLandmarkType.leftShoulder,
          PoseLandmarkType.leftElbow, canvas, scaleX, scaleY, linePaint);

      drawLine(pose, PoseLandmarkType.leftElbow,
          PoseLandmarkType.leftWrist, canvas, scaleX, scaleY, linePaint);

      drawLine(pose, PoseLandmarkType.rightShoulder,
          PoseLandmarkType.rightElbow, canvas, scaleX, scaleY, linePaint);

      drawLine(pose, PoseLandmarkType.rightElbow,
          PoseLandmarkType.rightWrist, canvas, scaleX, scaleY, linePaint);

      // Body
      drawLine(pose, PoseLandmarkType.leftShoulder,
          PoseLandmarkType.leftHip, canvas, scaleX, scaleY, linePaint);

      drawLine(pose, PoseLandmarkType.rightShoulder,
          PoseLandmarkType.rightHip, canvas, scaleX, scaleY, linePaint);

      // Legs
      drawLine(pose, PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee,
          canvas, scaleX, scaleY, linePaint);

      drawLine(pose, PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle,
          canvas, scaleX, scaleY, linePaint);

      drawLine(pose, PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee,
          canvas, scaleX, scaleY, linePaint);

      drawLine(pose, PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle,
          canvas, scaleX, scaleY, linePaint);
    }
  }

  void drawLine(
      Pose pose,
      PoseLandmarkType start,
      PoseLandmarkType end,
      Canvas canvas,
      double scaleX,
      double scaleY,
      Paint paint,
      ) {
    final p1 = pose.landmarks[start]!;
    final p2 = pose.landmarks[end]!;

    canvas.drawLine(
      Offset(p1.x * scaleX, p1.y * scaleY),
      Offset(p2.x * scaleX, p2.y * scaleY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
