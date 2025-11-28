import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/di.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  // updateAppState
  void updateAppState(){
    MyApp.instance.appState=0;
  }
  // getAppState
  void getAppState(){
    print(MyApp.instance.appState);//0
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
