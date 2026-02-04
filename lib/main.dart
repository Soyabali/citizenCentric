import 'package:citizencentric/presentation/resources/language_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'app/app.dart';
import 'app/di.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Import Riverpod
import 'package:flutter_easyloading/flutter_easyloading.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  //await initAppModule();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 // await HiveService.init();// have data base
  // Add a dependece here add all di.

  // ----hive table----
  await Hive.initFlutter();
  await Hive.openBox('loginBox');
  await Hive.openBox('registrationBox');
  await Hive.openBox('serverBox');
  //----end hive table----
  
  await initAppModule();
  initLoginModule(); // <--- ADD THIS LINE
  initChangePasswordModule(); // <--- ADD THIS LINE
  initHomeModule(); // <--- ADD THIS LINE
  initFirebaseModule();
  configLoading();// flutterEasyLoading
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
// create a easy loading function
void configLoading() {
  EasyLoading.instance

    ..displayDuration = const Duration(milliseconds: 2000)

    ..indicatorType = EasyLoadingIndicatorType.fadingCircle

    ..loadingStyle = EasyLoadingStyle.custom

    ..indicatorSize = 45.0

    ..radius = 10.0

    ..progressColor = Colors.white

    ..backgroundColor = Colors.black

    ..indicatorColor = Colors.white

    ..textColor = Colors.white

    ..maskColor = Colors.blue.withOpacity(0.5)

    ..userInteractions = false

    ..dismissOnTap = false;

}


