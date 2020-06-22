import 'package:flutter/material.dart';
import 'package:pothole_reporter/screens/welcome_screen.dart';
import 'package:pothole_reporter/screens/login_screen.dart';
import 'package:pothole_reporter/screens/registration_screen.dart';
import 'package:pothole_reporter/screens/camera_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

void main() => runApp(PotholeApp());

class PotholeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark().copyWith(
      //   textTheme: TextTheme(
      //     body1: TextStyle(color: Colors.black54),
      //   ),
      // ),
      home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        CameraScreen.id: (context) => CameraScreen(),
      },
    );
  }
}
