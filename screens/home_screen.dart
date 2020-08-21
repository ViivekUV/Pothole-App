import 'package:flutter/material.dart';
import 'package:pothole_reporter_app/screens/camera_screen.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 250.0,
                    child: Image.asset('images/icon-close.png'),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  Container(
                    width: 300,
                    height: 60,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      ),
                      onPressed: () {
//                      Navigator.push(context, MaterialPageRoute(builder: (context) =>getCurrentLocation()));
                        //_getCurrentLocation();
                        Navigator.pushNamed(context, CameraScreen.id);
                      },
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text('Press to report a pothole',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}

