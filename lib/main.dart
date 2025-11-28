import 'package:citizencentric/presentation/hive-database/hive_database.dart';
import 'package:citizencentric/presentation/resources/language_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'app/app.dart';
import 'app/di.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Import Riverpod


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  //await initAppModule();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HiveService.init();// have data base
  // Add a dependece here add all di.
  await initAppModule();
  initLoginModule(); // <--- ADD THIS LINE
  initChangePasswordModule(); // <--- ADD THIS LINE
  initHomeModule(); // <--- ADD THIS LINE
  initFirebaseModule();
  //await Hive.initFlutter();
  runApp(EasyLocalization(
      supportedLocales: [ENGLISH_LOCAL,ARABIC_LOCAL],
      path: ASSETS_PATH_LOCALISATIONS,
      child: ProviderScope(
        child: Phoenix(
            child: MyApp()),
      ),
      ));
}

