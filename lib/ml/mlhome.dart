
import 'package:camera/camera.dart';
import 'package:citizencentric/ml/pose_dector.dart';
import 'package:citizencentric/ml/realtimeimagelabeling.dart';
import 'package:citizencentric/ml/smartReply.dart';
import 'package:citizencentric/ml/textrecognigation.dart';
import 'package:citizencentric/ml/texttranslation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'barcode_scanning.dart';
import 'face_dection.dart';
import 'imagelabeling.dart';
import 'objectDection.dart';


class MLHomeScreen extends StatefulWidget {
  const MLHomeScreen({super.key});

  @override
  State<MLHomeScreen> createState() => _MyHomeState();
}

class _MyHomeState extends State<MLHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
    appBar: AppBar(
      title: Text('ML Kit',style: TextStyle(
        color: Colors.black,
        fontSize: 16
      ),),
    ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
             SizedBox(height: 25),
             ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,            // Button background
              foregroundColor: Colors.white,            // Text color
              shape: const StadiumBorder(),             // Stadium shape
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            onPressed: () {
              // TODO: your function here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImageLabeling()),
              );
              print('------ImageLabeling-----');
            }, child: Text('Image Labeling',style: TextStyle(
               color: Colors.white,
               fontSize: 16
             ),),),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,            // Button background
                  foregroundColor: Colors.white,            // Text color
                  shape: const StadiumBorder(),             // Stadium shape
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  // TODO: your function here
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RealTimeImageLabeling()));
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => RealTimeImageLabeling(cameras: cameras)));
                  print('------ImageLabeling-----');
                }, child: Text(' RealTime Image Labeling',style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),),),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,            // Button background
                  foregroundColor: Colors.white,            // Text color
                  shape: const StadiumBorder(),             // Stadium shape
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  // TODO: your function here
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BarcodeScanning()));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => BarcodeScanning(cameras: cameras)));
                  print('------ImageLabeling-----');
                }, child: Text('BarCodeScanning',style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),),),
              //  TextRecognition
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,            // Button background
                  foregroundColor: Colors.white,            // Text color
                  shape: const StadiumBorder(),             // Stadium shape
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  // TODO: your function here
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TextRecognitionScreen()));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => TextRecognitionScreen(cameras: cameras)));
                  print('------ImageLabeling-----');
                }, child: Text('TextRecognition',style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),),),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,            // Button background
                  foregroundColor: Colors.white,            // Text color
                  shape: const StadiumBorder(),             // Stadium shape
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  // TODO: your function here
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FaceDetectionScreen()));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => FaceDection2(cameras: cameras)));
                  print('------ImageLabeling-----');
                }, child: Text('FaceDetection',style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),),),
              // Object Dection
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,            // Button background
                  foregroundColor: Colors.white,            // Text color
                  shape: const StadiumBorder(),             // Stadium shape
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  // TODO: your function here
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ObjectDetectionScreen()));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => ObjectDetectionScreen(cameras: cameras)));

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => FaceDection2(cameras: cameras)));
                  print('------ImageLabeling-----');
                }, child: Text('ObjectDetection',style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),),),
              // PoseDection
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,            // Button background
                  foregroundColor: Colors.white,            // Text color
                  shape: const StadiumBorder(),             // Stadium shape
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  // TODO: your function here
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PoseDetectionScreen()));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => ObjectDetectionScreen(cameras: cameras)));

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => FaceDection2(cameras: cameras)));
                  print('------ImageLabeling-----');
                }, child: Text('PoseDetection',style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),),),
              // TextTranslation
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,            // Button background
                  foregroundColor: Colors.white,            // Text color
                  shape: const StadiumBorder(),             // Stadium shape
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  // TODO: your function here
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TextTranslation()));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => ObjectDetectionScreen(cameras: cameras)));

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => FaceDection2(cameras: cameras)));
                  print('------ImageLabeling-----');
                }, child: Text('TextTranslation',style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),),),
              // Smart Reply
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,            // Button background
                  foregroundColor: Colors.white,            // Text color
                  shape: const StadiumBorder(),             // Stadium shape
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  // TODO: your function here
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SmartReplyScreen()));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => ObjectDetectionScreen(cameras: cameras)));

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => FaceDection2(cameras: cameras)));
                  print('------ImageLabeling-----');
                }, child: Text('Smart Reply',style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),),),

            ],
          ),
        ),
    )
    );
  }
}
