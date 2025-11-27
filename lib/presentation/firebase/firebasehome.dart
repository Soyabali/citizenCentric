
import 'package:flutter/material.dart';

import 'auth/auth.dart';
import 'auth/chat.dart';
import 'auth/firebaseSplaceScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseHome extends StatelessWidget {
  const FirebaseHome({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FlutterChat',
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 63, 17, 177)),
        ),
        home: StreamBuilder(
            //stream: FirebaseAuth.instance.authStateChanges(),
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const FireBaseSplashScreen();
              }
              if (snapshot.hasData) {
                return const ChatScreen();
              }
              return const AuthScreen();
            }));
  }
}