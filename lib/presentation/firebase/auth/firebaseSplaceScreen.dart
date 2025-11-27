
import 'package:flutter/material.dart';

class FireBaseSplashScreen extends StatelessWidget {
  const FireBaseSplashScreen({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
      ),
      body: const Center(
        child: Text('Loading...'),
      ),
    );
  }
}