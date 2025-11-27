import 'package:flutter/material.dart';

class FirebaseLogin extends StatefulWidget {
  const FirebaseLogin({super.key});

  @override
  State<FirebaseLogin> createState() => _FirebaseLoginState();
}

class _FirebaseLoginState extends State<FirebaseLogin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firebase',style: TextStyle(
            color: Colors.black,
            fontSize: 16
          ),),
        ),
        body: Center(
          child: Text('FireBase',style: TextStyle(
            color: Colors.black,
            fontSize: 16
          ),),
        ),
      ),
    );
  }
}
