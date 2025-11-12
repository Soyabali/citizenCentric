import 'package:citizencentric/presentation/resources/theme_manager.dart';
import 'package:flutter/material.dart';

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
      theme: getApplicationTheme(),
      // home
      home: Scaffold(
        appBar: AppBar(title: Text('MyApp',style: TextStyle(
          color: Colors.black
        ),),),
        body: Center(
          child: Text('Flutter',style: TextStyle(
            color: Colors.black,
            fontSize: 16
          ),),
        ),
      ),
    );
  }
}
