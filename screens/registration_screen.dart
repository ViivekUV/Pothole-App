// With OTP
import 'package:flutter/material.dart';
import 'package:pothole_reporter_app/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pothole_reporter_app/screens/login_screen.dart';


class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String name;
  String email;
  String password;
  bool showSpinner = false;
  bool emailVerified = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 200.0,
                child: Image.asset('images/icon-close.png'),
              ),
              SizedBox(
                height: 48.0,
              ),
//              TextField(
//                textAlign: TextAlign.center,
//                onChanged: (value) {
//                  name = value;
//                },
//                decoration: InputDecoration(
//                  hintText: 'Enter your name',
//                  contentPadding:
//                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
//                  border: OutlineInputBorder(
//                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                  ),
//                  enabledBorder: OutlineInputBorder(
//                    borderSide: BorderSide(color: Colors.black, width: 1.0),
//                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                  ),
//                  focusedBorder: OutlineInputBorder(
//                    borderSide: BorderSide(color: Colors.black, width: 2.0),
//                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                  ),
//                ),
//              ),
//              SizedBox(
//                height: 8.0,
//              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Sign Up',
                color: Colors.black,
                onPressed: () async{
                  setState(() {
                    showSpinner = true;
                  });
                  try {
//                    try{
//                      final newUser = await _auth.createUserWithEmailAndPassword(
//                          email: email,
//                          password: password
//                      );
//                    }
//                    catch (e) {
//                      _showErrorDialog(e);
                    final newUser = await _auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password
                    );
                    FirebaseUser user = await _auth.currentUser();
                    user.sendEmailVerification();
                    _showVerifyEmailSentDialog(user);
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    _showErrorDialog(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showVerifyEmailSentDialog(FirebaseUser user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Link to verify account has been sent to your email. Tap on it and then click on the below button."),
          actions: <Widget>[
            new FlatButton(
              onPressed: () async
              {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              child: Text('Ok')
            )
          ],
        );
      },
    );
  }
  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("$error"),
          content: new Text("Please try registering again."),
          actions: <Widget>[
            new FlatButton(
                onPressed: () async
                {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                child: Text('Ok')
            )
          ],
        );
      },
    );
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }
}


// import 'package:flutter/material.dart';
// import 'package:pothole_reporter_app/components/rounded_button.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:pothole_reporter_app/screens/camera_screen.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';


// class RegistrationScreen extends StatefulWidget {
//   static String id = 'registration_screen';
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final _auth = FirebaseAuth.instance;
//   String email;
//   String password;
//   bool showSpinner = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: ModalProgressHUD(
//         inAsyncCall: showSpinner,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Container(
//                 height: 200.0,
//                 child: Image.asset('images/icon-close.png'),
//               ),
//               SizedBox(
//                 height: 48.0,
//               ),
//               TextField(
//                 textAlign: TextAlign.center,
//                 onChanged: (value) {
//                   email = value;
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Enter your name',
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black, width: 1.0),
//                     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black, width: 2.0),
//                     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 8.0,
//               ),
//               TextField(
//                 keyboardType: TextInputType.emailAddress,
//                 textAlign: TextAlign.center,
//                 onChanged: (value) {
//                   email = value;
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Enter your email',
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black, width: 1.0),
//                     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black, width: 2.0),
//                     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 8.0,
//               ),
//               TextField(
//                 obscureText: true,
//                 textAlign: TextAlign.center,
//                 onChanged: (value) {
//                   password = value;
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Enter your password',
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black, width: 1.0),
//                     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black, width: 2.0),
//                     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 24.0,
//               ),
//               RoundedButton(
//                 title: 'Register',
//                 color: Colors.black,
//                 onPressed: () async{
//                   setState(() {
//                     showSpinner = true;
//                   });
//                   try {
//                     final newUser = await _auth.createUserWithEmailAndPassword(
//                       email: email, 
//                       password: password
//                     );
//                     if(newUser != null){
//                       Navigator.pushNamed(context, CameraScreen.id);

//                       setState(() {
//                         showSpinner = false;
//                       });
//                     }
//                   } catch (e) {
//                     print(e);
//                   }                
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
