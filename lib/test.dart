import 'package:flutter/material.dart';
import 'app/app.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  // updateAppState
  void updateAppState(){
    MyApp.instance.appState=0;
  }
  // getAppState
  void getAppState(){
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
