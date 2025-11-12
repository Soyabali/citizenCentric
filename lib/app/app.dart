import 'package:citizencentric/presentation/resources/theme_manager.dart';
import 'package:flutter/material.dart';

import '../presentation/resources/routes_manager.dart';

class MyApp extends StatefulWidget {

  MyApp._internal();// private named constructor
  int appState=0;
  static final MyApp instance = MyApp._internal();// single instance --singleton

  factory MyApp() => instance; // factort for the class instance

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application Theme
      debugShowCheckedModeBanner: false,
      // rooute
      onGenerateRoute: RouteGenerator.getRoute,
      // inittialRoute
      initialRoute: Routes.splashRoute,
     // theme
      theme: getApplicationTheme(),
    );
  }
}
