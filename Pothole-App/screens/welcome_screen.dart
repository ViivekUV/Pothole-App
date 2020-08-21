
import 'package:flutter/material.dart';
import 'dart:io';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:pothole_reporter_app/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternetAccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Hero(
                  tag: 'icon',
                  child: Container(
                    child: Image.asset('images/icon-close.png'),
                    height: 90.0,
                    alignment: Alignment.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0)
                ),
                Text(
                  'Pothole Reporter',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10.0)
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In', 
              color: Colors.grey, 
              onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: 'Sign Up',
              color: Colors.black, 
              onPressed: () {
              Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("$error"),
          content: new Text("Please try again."),
          actions: <Widget>[
            new FlatButton(
                onPressed: () async
                {
                  Navigator.pushNamed(context, WelcomeScreen.id);
                },
                child: Text('Ok')
            )
          ],
        );
      },
    );
  }
  void checkInternetAccess () async{
    try {
      final result = await InternetAddress.lookup(
          'google.com');
      if (result.isNotEmpty &&
          result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
      _showErrorDialog('No Internet Access');
    }
  }
}

