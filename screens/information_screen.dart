
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:pothole_reporter_app/components/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:pothole_reporter_app/screens/camera_screen.dart';
import 'dart:convert';

import 'package:pothole_reporter_app/screens/complaint_registered_screen.dart';
import 'package:pothole_reporter_app/screens/welcome_screen.dart';

class InformationScreen extends StatefulWidget {
  static String id = 'information_screen';
  String url;
  String address;
  // receive data from the FirstScreen as a parameter
  InformationScreen({Key key, @required this.url, @required this.address}) : super(key: key);
  @override
  _InformationScreenState createState() => _InformationScreenState(url, address);
}

class _InformationScreenState extends State<InformationScreen> { 
  String url;
  String address;
  _InformationScreenState(this.url, this.address);
  // final _auth = FirebaseAuth.instance;
  String name;
  String text;
  String number;
  double lat;
  double lng;
  bool showSpinner = false;
  final List users = [];

  Geolocator geolocator = Geolocator();
  Address userLocation;
  @override
  void initState() {
    super.initState();
    _getLocation().then((position) {
      userLocation = position;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Your Location is',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                '$address',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  name = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (value) {
                 number = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  text = value;
                },
                decoration: InputDecoration(
                  hintText: 'Describe the pothole',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              // RaisedButton.icon(
              //   onPressed: (){ 
              //     _getLocation();
              //   },
              //   shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.all(Radius.circular(10.0))),
              //   label: Text(
              //     'Detect location', 
              //     style: TextStyle(color: Colors.black),
              //   ),
              //   icon: Icon(Icons.location_on, color:Colors.black,), 
              //   textColor: Colors.black,
              //   splashColor: Colors.grey[300],
              //   color: Colors.grey,
              // ),
              // userLocation == null
              // address == null
              //   ? Text('')
              //   : Text(
              //     // "Location:" + userLocation.featureName.toString() + " " + userLocation.addressLine.toString()
              //     "Ready to register complaint! Click below"
              //   ),
              SizedBox(
                height: 24.0,
              ),
              // Text('$url'),
              RoundedButton(
                title: 'Register Complaint',
                color: Colors.black,
                onPressed: () async{
                  setState(() {
                    showSpinner = true;
                  });
                  try{
                    if (number.length!=10 && address!=null) {
                      _showErrorDialog('Invalid Number');
                    }
                    else {
                      sendData();
                      Navigator.pushNamed(context, ComplaintRegisteredScreen.id);
                    }

                  }
                  catch (e) {
                    _showErrorDialog(e);
                  }
                  setState(() {
                    showSpinner = false;
                  });
                  // try {
                  //   final newUser = await _auth.createUserWithEmailAndPassword(
                  //     email: email, 
                  //     password: password
                  //   );
                  //   if(newUser != null){
                  //     Navigator.pushNamed(context, CameraScreen.id);

                  //     setState(() {
                  //       showSpinner = false;
                  //     });
                  //   }
                  // } catch (e) {
                  //   print(e);
                  // }                
                },
              ),
            ],
          ),
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
                  Navigator.pushNamed(context, CameraScreen.id);
                },
                child: Text('Ok')
            )
          ],
        );
      },
    );
  }

  Future<Address> _getLocation() async
  {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    Address first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    lat = position.latitude;
    lng = position.longitude;
    address = first.addressLine;
    // print(first.runtimeType);
    return first;
  }
  sendData() {
    http.post("https://pothole-reporter-app.firebaseio.com/users.json",
        body: json.encode({
          'name': name,
          'number': number,
          'text': text,
          'location': address,
          'latitude': lat,
          'longitude': lng,
          'image': url
        }));
    setState(() {
      users.add(Profile(
        name: name,
        number: number,
        text: text,
        location: address,
        latitude: lat,
        longitude: lng,
        image: url
      ));
//      Navigator.pushNamed(context, ComplaintRegisteredScreen.id);
    });

  }
}
      
class Profile {
  String name;
  String number;
  String text;
  String location;
  double latitude;
  double longitude;
  String image;
  Profile({
    @required this.name,
    @required this.number,
    @required this.text,
    @required this.location,
    @required this.latitude,
    @required this.longitude,
    @required this.image,
  });
}