// lib/presentation/formdatastore/image_input.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    // Launch the device camera
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 60,
      maxWidth: 400, // Constrain the image size to save space
    );

    if (pickedImage == null) {
      return; // User canceled the camera
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    // Pass the selected image back to the parent widget (the form)
    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _takePicture,
      icon: const Icon(Icons.camera),
      label: const Text('Take Picture'),
    );

    if (_selectedImage != null) {
      // If an image has been picked, show it in the preview box
      content = GestureDetector(
        onTap: _takePicture, // Allow tapping the image to retake it
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
      ),
      child: content,
    );
  }
}
