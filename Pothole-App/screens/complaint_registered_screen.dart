import 'package:flutter/material.dart';


class ComplaintRegisteredScreen extends StatefulWidget {
  static String id = 'complaint_registered_screen';
  @override
  _ComplaintRegisteredState createState() => _ComplaintRegisteredState();
}

class _ComplaintRegisteredState extends State<ComplaintRegisteredScreen> {
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
                Container(
                  child: Image.asset('images/icon-close.png'),
                  height: 220.0,
                  alignment: Alignment.center,
                ),
                Padding(
                    padding: EdgeInsets.all(20.0)
                ),
                Text(
                  'Complaint Registered',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.all(10.0)
            ),
            SizedBox(
              height: 28.0,
            ),
            Container(
              child: Image.asset('images/check.png'),
              height: 60.0,
              alignment: Alignment.center,
            )
          ],
        ),
      ),
    );
  }
}

