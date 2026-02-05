import 'package:flutter/material.dart';

class FullScreenImageDialog extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageDialog({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black, // fullscreen background
      child: SafeArea(
        child: Stack(
          children: [
            // IMAGE
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),

            // CLOSE BUTTON
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.pop(context); // ✅ closes dialog only
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
