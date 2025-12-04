
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class BarcodeScanning extends StatefulWidget {
  //final List<CameraDescription> cameras;

  const BarcodeScanning({Key? key}) : super(key: key);

  @override
  State<BarcodeScanning> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<BarcodeScanning> {
  late CameraController controller;
  CameraImage? img;
  bool isBusy = false;
  String result = "results will be shown";
  late List<CameraDescription> cameras;

  //TODO declare scanner
  dynamic barcodeScanner;


  // ----ui component----
  List<Widget> _buildResultList() {
    List<String> lines = result.trim().split("\n");

    return lines.map((line) {
      final parts = line.split("   ");
      final label = parts[0];
      final conf = parts.length > 1 ? parts[1] : "";
      // here you can save the barCode no issue.


      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              conf,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
  //---end ui component---
  @override
  void initState() {
    super.initState();
    //TODO initialize scanner
    _loadCameras();

    // ML Kit barcode formats
    final List<BarcodeFormat> formats = [BarcodeFormat.all];
    barcodeScanner = BarcodeScanner(formats: formats);
    // final List<BarcodeFormat> formats = [BarcodeFormat.all];// here barCode scan all format there is in a ml kit
    // barcodeScanner = BarcodeScanner(formats: formats);
    //
    // //TODO initialize the controller
    // controller = CameraController(
    //   widget.cameras[0],// here back camra
    //   ResolutionPreset.high,
    //   imageFormatGroup: Platform.isAndroid
    //       ? ImageFormatGroup.nv21 // for Android
    //       : ImageFormatGroup.bgra8888,);
    // controller.initialize().then((_) {
    //   if (!mounted) {
    //     return;
    //   }
    //   controller.startImageStream((image) => {
    //     if (!isBusy) {isBusy = true, img = image, doBarcodeScanning()}
    //   });
    //   setState(() {});
    // }).catchError((Object e) {
    //   if (e is CameraException) {
    //     switch (e.code) {
    //       case 'CameraAccessDenied':
    //         print('User denied camera access.');
    //         break;
    //       default:
    //         print('Handle other errors.');
    //         break;
    //     }
    //   }
    // });
  }
  // STEP 1 → Load camera list internally
  Future<void> _loadCameras() async {
    cameras = await availableCameras();
    initializeCamera();
  }

  // STEP 2 → Initialize camera after loading list
  Future<void> initializeCamera() async {
    controller = CameraController(
      cameras[0], // back camera
      ResolutionPreset.high,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await controller.initialize();

    controller.startImageStream((image) {
      if (!isBusy) {
        isBusy = true;
        img = image;
        doBarcodeScanning();
      }
    });

    if (mounted) setState(() {});
  }

  //TODO barcode scanning code here
  doBarcodeScanning() async {
    result = "";
    InputImage? inputImg = getInputImage();
    final List<Barcode> barcodes = await barcodeScanner.processImage(inputImg);

    for (Barcode barcode in barcodes) {
      final BarcodeType type = barcode.type;
      final Rect? boundingBox = barcode.boundingBox;
      final String? displayValue = barcode.displayValue;
      final String? rawValue = barcode.rawValue;

      // See API reference for complete list of supported types
      switch (type) {
        case BarcodeType.wifi:
          BarcodeWifi? barcodeWifi = barcode.value as BarcodeWifi?;
          if(barcodeWifi !=null) {
            result = "Wifi: ${barcodeWifi.password!}";
          }
          break;
        case BarcodeType.url:
          BarcodeUrl? barcodeUrl = barcode.value as BarcodeUrl;
          if(barcodeUrl != null) {
            result = "Url: ${barcodeUrl.url!}";
          }
          break;
        case BarcodeType.unknown:
        // TODO: Handle this case.
        case BarcodeType.contactInfo:
        // TODO: Handle this case.
        case BarcodeType.email:
        // TODO: Handle this case.
        case BarcodeType.isbn:
        // TODO: Handle this case.
        case BarcodeType.phone:
        // TODO: Handle this case.
        case BarcodeType.product:
        // TODO: Handle this case.
        case BarcodeType.sms:
        // TODO: Handle this case.
        case BarcodeType.text:
        // TODO: Handle this case.
        case BarcodeType.geoCoordinates:
        // TODO: Handle this case.
        case BarcodeType.calendarEvent:
        // TODO: Handle this case.
        case BarcodeType.driverLicense:
        // TODO: Handle this case.
      }
    }
    setState(() {
      result;
      isBusy = false;
    });
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };
  InputImage? getInputImage() {
    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
    final camera = cameras[1];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientations[controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(img!.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (img?.planes.length != 1) return null;
    final plane = img?.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane!.bytes,
      metadata: InputImageMetadata(
        size: Size(img!.width.toDouble(), img!.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
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
        title: const Text("BarCode Scanning"),
        backgroundColor: Colors.black87,
        elevation: 2,
      ),

      backgroundColor: Colors.black,

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // =============================
            //  CAMERA PREVIEW (80% height)
            // =============================
            Expanded(
              flex: 8, // 80%
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: CameraPreview(controller),
              ),
            ),

            const SizedBox(height: 10),

            // =============================
            //   LABEL RESULT CARD
            // =============================
            Expanded(
              flex: 2, // 20%
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
                          fontSize: 18,
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