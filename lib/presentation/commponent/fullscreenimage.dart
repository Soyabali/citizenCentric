import 'package:flutter/material.dart';

import '../resources/strings_manager.dart';
import 'appbarcommon.dart';

class FullScreenPage extends StatelessWidget {

  final sBeforePhoto;

  const FullScreenPage({super.key,required this.sBeforePhoto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppCommonAppBar(
        title: "Image View", // title: "Park Geotagging",
        showBack: true,
        onBackPressed: () {
          print("Back pressed");
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          sBeforePhoto != null && sBeforePhoto.isNotEmpty
              ? Image.network(
            sBeforePhoto,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text(
                  "No Image",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              );
            },
          )
              : const Center(
            child: Text(
              "No Image",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),

          // Close button
          Positioned(
            top: 5.0,
            right: 10.0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red,size: 50),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
