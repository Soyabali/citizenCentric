
// Step 1: Import flutter_riverpod and your provider file

import 'package:flutter_riverpod/flutter_riverpod.dart';// <--- UPDATE THIS PATH
import 'dart:io'; // Needed for the 'File' type

import 'package:flutter/material.dart';
import '../../app/camra.dart';
import '../../app/di.dart';
import '../../data/network/network_info.dart';
import '../../domain/model/model.dart';
import '../riverpod/user_place.dart';

// Step 2: Change StatefulWidget to ConsumerStatefulWidget
class FormDataStore extends ConsumerStatefulWidget {
  const FormDataStore({super.key});

  @override
  // Step 3: Change State to ConsumerState
  ConsumerState<FormDataStore> createState() => _FormDataStoreState();
}

// Step 4: Change State to ConsumerState<FormDataStore>
class _FormDataStoreState extends ConsumerState<FormDataStore> {
  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();
  final TextEditingController _field3Controller = TextEditingController();
  final TextEditingController _field4Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final NetworkInfo _networkInfo = instance<NetworkInfo>();
  //late NetworkInfo _networkInfo;
  // You will also need an image file to save. Let's add a placeholder.
  File? _selectedImage;

  @override
  void dispose() {
    _field1Controller.dispose();
    _field2Controller.dispose();
    _field3Controller.dispose();
    _field4Controller.dispose();
    super.dispose();
  }

  // In your formdatastore.dart file

  void _handlePush() async {
    // First, validate the form. If it fails, do nothing.
    if (!_formKey.currentState!.validate()) {
      print("Form is not valid. Please fill all fields.");
      return;
    }

    if (_selectedImage == null) {
      print("No image selected.");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please select an image.')));
      return;
    }

    // --- Check for internet connection ---
    if (await _networkInfo.isConnected) {
      print('Internet is connected.');

      // --- SOLUTION STARTS HERE ---
      // 1. LOAD: Explicitly tell the provider to load data from the database into its state.
      print('Checking for local data in database...');
      await ref.read(userPlacesProvider.notifier).loadPlaces();

      // 2. READ: NOW, read the state. It will contain the data you just loaded.
      final List<Place> localPlaces = ref.read(userPlacesProvider);

      print('------ Found ${localPlaces.length} locally stored items. ---');

      // --- SOLUTION ENDS HERE ---


      // 3. Check if there is any local data to sync.
      if (localPlaces.isNotEmpty) {
        print('--- Syncing ${localPlaces.length} item(s) to server... ---');

        // Loop through the local data and "upload" it.
        for (final place in localPlaces) {
          print('Uploading: Title: ${place.title}, Image Path: ${place.image.path}');
          // TODO: Implement your actual API call here to upload each `place`.
          // For example: await myApi.uploadPlace(place);
        }
        print('--- Sync complete. ---');

        // After successful upload, clear the local database.
        await ref.read(userPlacesProvider.notifier).clearAllPlaces();
        if (mounted) { // Good practice to check if widget is still visible
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Successfully synced local data to server!')));
        }

      } else {
        print('No local data to sync.');
      }

      // --- Now, submit the CURRENT form data to the API ---
      print('Submitting current form data via API...');
      // TODO: Add your API call logic here...

      // Clear the form after successful API submission
      _field1Controller.clear();
      _field2Controller.clear();
      _field3Controller.clear();
      _field4Controller.clear();
      setState(() {
        _selectedImage = null;
      });

    } else {
      // --- NO INTERNET CONNECTION ---
      print('No internet connection. Saving data to local database.');

      ref.read(userPlacesProvider.notifier).addPlace(
        _field1Controller.text,
        _selectedImage!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No internet. Saved data locally.')));
      }

      // Clear the form...
      _field1Controller.clear();
      _field2Controller.clear();
      _field3Controller.clear();
      _field4Controller.clear();
      setState(() {
        _selectedImage = null;
      });
    }
  }

  // void _handlePush() async {
  //   // First, validate the form. If it fails, do nothing.
  //   if (!_formKey.currentState!.validate()) {
  //     print("Form is not valid. Please fill all fields.");
  //     return;
  //   }
  //   // Use a real image picker in a real app
  //  // _selectedImage = File('path/to/your/dummy/image.jpg');
  //   if (_selectedImage == null) {
  //     print("No image selected.");
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(const SnackBar(content: Text('Please select an image.')));
  //     return;
  //   }
  //
  //   // --- Check for internet connection ---
  //   if (await _networkInfo.isConnected) {
  //     print('Internet is connected.');
  //
  //     // --- NEW LOGIC STARTS HERE ---
  //     // 1. Get the current list of locally stored places from the provider.
  //     final List<Place> localPlaces = ref.read(userPlacesProvider);
  //     print('------67---- Found ${localPlaces.length} locally stored items. ---');
  //
  //
  //     // 2. Check if there is any local data to sync.
  //     if (localPlaces.isNotEmpty) {
  //       print('--- Found ${localPlaces.length} locally stored items. Syncing to server... ---');
  //
  //       // 3. Loop through the local data and "upload" it.
  //       for (final place in localPlaces) {
  //         print('Uploading: Title: ${place.title}, Image Path: ${place.image.path}');
  //         // TODO: Implement your actual API call here to upload each `place`.
  //         // For example: await myApi.uploadPlace(place);
  //       }
  //       print('--- Sync complete. ---');
  //
  //       // 4. After successful upload, clear the local database.
  //       // We call the new method on our provider.
  //       await ref.read(userPlacesProvider.notifier).clearAllPlaces();
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Successfully synced local data to server!')));
  //     } else {
  //        print('No local data to sync.');
  //      }
  //     // --- NEW LOGIC ENDS ---
  //
  //
  //     // --- Now, submit the CURRENT form data to the API ---
  //     print('Submitting current form data via API...');
  //     final String field1Value = _field1Controller.text;
  //     // TODO: Add your API call logic here for the new data from the form.
  //     // For example: await myApi.uploadPlace(Place(title: field1Value, image: _selectedImage!));
  //
  //     // Clear the form after successful API submission
  //     _field1Controller.clear();
  //     _field2Controller.clear();
  //     _field3Controller.clear();
  //     _field4Controller.clear();
  //     setState(() {
  //       _selectedImage = null;
  //     });
  //
  //   } else {
  //     // --- NO INTERNET CONNECTION ---
  //     // This part remains the same.
  //     print('No internet connection. Saving data to local database.');
  //
  //     ref.read(userPlacesProvider.notifier).addPlace(
  //       _field1Controller.text,
  //       _selectedImage!,
  //     );
  //
  //     print('Data for "${_field1Controller.text}" saved locally!');
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('No internet. Saved data locally.')));
  //
  //     // Clear the form for the next entry
  //     _field1Controller.clear();
  //     _field2Controller.clear();
  //     _field3Controller.clear();
  //     _field4Controller.clear();
  //     setState(() {
  //       _selectedImage = null;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // You should not return a MaterialApp here. Your main.dart should have the MaterialApp.
    // This causes issues with navigation and themes.
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Form Data Storage',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: Text('Store Data', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold))),
                const SizedBox(height: 24),

                 //camra code
                ImageInput(
                  onPickImage: (image) {
                    // This callback function receives the image from the ImageInput widget
                    // and stores it in the state variable for this form.
                    _selectedImage = image;
                    print("-------169---$_selectedImage");
                  },
                ),
                SizedBox(height: 20),
                // Add validators to your TextFormFields
                TextFormField(
                  controller: _field1Controller,
                  decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder(),),
                  validator: (value) {
                    if(value == null || value.trim().isEmpty) {
                      return 'Please enter a title.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _field2Controller,
                  decoration: const InputDecoration(labelText: 'Field 2', border: OutlineInputBorder()),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Cannot be empty' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _field3Controller,
                  decoration: const InputDecoration(labelText: 'Field 3', border: OutlineInputBorder()),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Cannot be empty' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _field4Controller,
                  decoration: const InputDecoration(labelText: 'Field 4', border: OutlineInputBorder()),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Cannot be empty' : null,
                ),

                // TODO: You need a button here to pick an image for your database

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _handlePush,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Push'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

