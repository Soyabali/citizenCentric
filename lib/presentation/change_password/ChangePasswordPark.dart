import 'package:flutter/material.dart';


class ChangePasswordPark extends StatefulWidget {
  const ChangePasswordPark({super.key});

  @override
  State<ChangePasswordPark> createState() => _ChangePasswordParkState();
}

class _ChangePasswordParkState extends State<ChangePasswordPark> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('ChangePassword'),),
        body: Center(
          child: Text('ChangePassword'),
        ),
      ),
    );
  }
}
