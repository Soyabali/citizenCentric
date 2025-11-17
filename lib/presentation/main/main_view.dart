import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home: Scaffold(
         // appBar
         backgroundColor: Colors.white,
         appBar: AppBar(
           title: Text('Home Page',style: TextStyle(
             color: Colors.black,
             fontSize: 16
           ),),
         ),
         body: Center(
           child: Text('Flutter Application',style: TextStyle(
             color: Colors.black,
             fontSize: 16
           ),),
         ),
       ),
    );
  }
}