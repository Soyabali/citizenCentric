
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Register Page',style: TextStyle(
            color: Colors.black
          ),),
        ),
        body: Center(
          child: Text('Register',style: TextStyle(
            color: Colors.black,
            fontSize: 16
          ),),
        ),
      ),
    );
  }
}