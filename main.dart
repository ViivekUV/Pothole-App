import 'package:flutter/material.dart';
import 'package:pothole_reporter_app/screens/complaint_registered_screen.dart';
import 'package:pothole_reporter_app/screens/home_screen.dart';
import 'package:pothole_reporter_app/screens/welcome_screen.dart';
import 'package:pothole_reporter_app/screens/login_screen.dart';
import 'package:pothole_reporter_app/screens/registration_screen.dart';
import 'package:pothole_reporter_app/screens/camera_screen.dart';
import 'package:pothole_reporter_app/screens/information_screen.dart';

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
        HomeScreen.id: (context) => HomeScreen(),
        CameraScreen.id: (context) => CameraScreen(),
        InformationScreen.id: (context) => InformationScreen(),
        ComplaintRegisteredScreen.id: (context) => ComplaintRegisteredScreen(),
      },
    );
  }
}
