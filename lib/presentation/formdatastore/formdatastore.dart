
// Step 1: Import flutter_riverpod and your provider file

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';// <--- UPDATE THIS PATH
import 'dart:io'; // Needed for the 'File' type
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../app/camra.dart';
import '../../app/di.dart';
import '../../data/network/network_info.dart';
import '../hive-database/hive_database.dart';
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

  final box = HiveService.myBox;// hive database access
  late StreamSubscription<InternetStatus> _listener;

  @override
  void initState() {

    super.initState();
    // Listen to internet changes
    _listener = InternetConnection().onStatusChange.listen((status) {
      if (status == InternetStatus.connected) {
        print("Internet Connected → Auto Syncing...");
        _handlePush();   // 🔥 Auto Push / Sync Hive Data
      } else {
        print("Internet Disconnected");
      }
    });
  }

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
    final box = Hive.box('myBox');

    if (await _networkInfo.isConnected)
    {
      print('Internet is connected.');
      // Convert Hive data into List<Map>
      final dataMap = box.toMap();// To get a stored data as a Map
      final List<Map<String, dynamic>> items = [];

      dataMap.forEach((key, value) {
        items.add({"key": key, "value": value});
      });

      print("Items List Length: ${items.length}");

      if (items.isNotEmpty) {
        print("Data is already in the database");

        // SHOW all items
        for (var item in items) {
          print("${item['key']} : ${item['value']}");
        }

        // TODO: CALL YOUR API HERE
        print("⏫ Sending to server...");
        // await ApiService.send(items);
        // After sending → clear local db
        await box.clear();
        print("Local data cleared after sync.");
      } else {
        print("Save new data");
      }

    } else {
      print('No Internet! Saving data locally.');

      // Put data in local hive
      box.put('name', 'Soyaib Ali');
      box.put('Company', 'Synergy');
      box.put('city', 'Noida');

      print("Local Data Saved Successfully.");
    }
  }



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

