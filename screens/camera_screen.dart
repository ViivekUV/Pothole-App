import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoder/geocoder.dart';
import 'package:pothole_reporter_app/screens/information_screen.dart';
import 'package:pothole_reporter_app/screens/welcome_screen.dart';
import 'package:tflite/tflite.dart';
import 'package:geolocator/geolocator.dart';

class CameraScreen extends StatefulWidget {
  static String id = 'camera_screen';
  createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  /// Active image file
  File _imageFile;
  bool _loading;
  var _outputs;


  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
    classifyImage(selected);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  void getCurrentUser()async{
    try {
      final user = await _auth.currentUser();
      if(user != null){
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: ModalProgressHUD(inAsyncCall: _loading, child: null)
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
//                Navigator.pop(context);
                Navigator.pushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: 
          Text(
            'Capture Pothole',
            style: TextStyle(color: Colors.white),
          ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.photo_camera,
                size: 30,
                color: Colors.black87
              ),
              onPressed: () => _pickImage(ImageSource.camera),
              color: Colors.black,
            ),
            IconButton(
              icon: Icon(
                Icons.photo_library,
                size: 30,
                color: Colors.black38
              ),
              onPressed: () => _pickImage(ImageSource.gallery),
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Container(
                padding: EdgeInsets.all(32), child: Image.file(_imageFile)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new FloatingActionButton(
                  heroTag: 'Crop',
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                  backgroundColor: Colors.grey,
                ),
                new FloatingActionButton(
                  heroTag: 'Refresh',
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                  backgroundColor: Colors.grey,
                ),
              ],
            ),
            if ("${_outputs[0]["index"]}" == "1") ...[
              Padding(
                padding: const EdgeInsets.all(32),
                child: Uploader(
                  file: _imageFile,
                )
              ),
              // Text(
              //   "Pothole Detected!",
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontSize: 20.0,
              //     background: Paint()..color = Colors.white,
              //   ),
              //   textAlign: TextAlign.center,
              // )
            ]
            else ...[
              SizedBox(
                height: 74.0,
              ),
              Text(
                'Pothole not detected',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Please try again',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ]
          ]
        ],
      ),
    );
  }
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }
  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}

/// Widget used to handle the management of
class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://pothole-reporter-app.appspot.com');
  String url;
  StorageUploadTask _uploadTask;
  bool flag = false;
  bool showSpinner = true;

  String address;

  Geolocator geolocator = Geolocator();
  Address userLocation;

  _startUpload() async{
    String filePath = 'images/${DateTime.now()}.png';
    _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
      StorageTaskSnapshot taskSnapshot = await _uploadTask.onComplete;
      // print(_uploadTask);
      url = (await taskSnapshot.ref.getDownloadURL());
      // print('URL Is $url');
      flag = true;
      
  }
  // _nextPage() async {
  //   await new Future.delayed(const Duration(seconds: 3), () {});
  //   if(flag == true){
      
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (!flag) {
      return Column(
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              Text(
                'Click the button to file complaint',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.0,
              ),
              showSpinner ? FloatingActionButton(
                elevation: 5.0,
                child: new Icon(Icons.navigate_next),
                backgroundColor: Colors.black,

                onPressed: () async{
                  setState(() {
                    showSpinner = false;
                  });
                  await _startUpload();
                  await _getLocation();
                  if(flag == true){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InformationScreen(url: url, address: address),
                      )
                    );
                  }
                  setState(() {
                    showSpinner = true;
                  });
                }
              )
//              FlatButton.icon(
//                color: Colors.grey[500],
//                label: Text(
//                  'Pothole Detected',
//                  style: TextStyle(
//                    color: Colors.white
//                  ),
//                ),
//                icon: Icon(Icons.done, color: Colors.white),
//                onPressed: () async{
//                  setState(() {
//                    showSpinner = false;
//                  });
//                  await _startUpload();
//                  if(flag == true){
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => InformationScreen(url: url),
//                      )
//                    );
//                  }
//                  setState(() {
//                    showSpinner = true;
//                  });
//
//                  // _nextPage();
//                  // if(flag == true){
//                  //   Navigator.push(
//                  //     context,
//                  //     MaterialPageRoute(
//                  //       builder: (context) => InformationScreen(url: url),
//                  //     )
//                  //   );
//                  // }
//
//                  // setState(() {
//                  //   showSpinner = false;
//                  // });
//                }
//              )
              : Center(child: CircularProgressIndicator())
            ]
          );
    }
    else {
      return Column(
        children: [
          Text(
            'Please Retry',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w900,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
  }
//  Future<Address> _getLocation() async
  _getLocation() async
  {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    Address first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    address = first.addressLine;
    // print(first.runtimeType);
//    return first;
  }
}


// Future<String> _startUpload() async{
//     String filePath = 'images/${DateTime.now()}.png';
//     StorageReference firebaseStorageRef = _storage.ref().child(filePath);
//     StorageUploadTask _uploadTask = firebaseStorageRef.putFile(widget.file);
//     StorageTaskSnapshot taskSnapshot = await _uploadTask.onComplete;
//     print(_uploadTask);

//     String url = (await taskSnapshot.ref.getDownloadURL());
//     print('URL Is $url');
//     // print(url.runtimeType);
//     return url;
//   }

// // Main code
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/widgets.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:pothole_reporter_app/components/rounded_button.dart';
// import 'package:tflite/tflite.dart';
// import 'information_screen.dart';

// class CameraScreen extends StatefulWidget {
//   static String id = 'camera_screen';
//   createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   /// Active image file
//   File _imageFile;

//   List _outputs;
//   File _image;
//   bool _loading = false;

//   bool showSpinner = false;
//   // final String urlGlobal = "";

//   final _auth = FirebaseAuth.instance;
//   FirebaseUser loggedInUser;

//   /// Cropper plugin
//   Future<void> _cropImage() async {
//     File cropped = await ImageCropper.cropImage(
//         sourcePath: _imageFile.path,
//     );

//     setState(() {
//       _imageFile = cropped ?? _imageFile;
//     });
//   }

//   /// Select an image via gallery or camera
//   Future<void> _pickImage(ImageSource source) async {
//     File selected = await ImagePicker.pickImage(source: source);

//     setState(() {
//       _imageFile = selected;
//     });
//     classifyImage(selected);
//   }

//   classifyImage(File image) async {
//     var output = await Tflite.runModelOnImage(
//       path: image.path,
//       numResults: 2,
//       threshold: 0.5,
//       imageMean: 127.5,
//       imageStd: 127.5,
//     );
//     setState(() {
//       _loading = false;
//       _outputs = output;
//     });
//   }

//   /// Remove image
//   void _clear() {
//     setState(() => _imageFile = null);
//   }

//   void getCurrentUser()async{
//     try {
//       final user = await _auth.currentUser();
//       if(user != null){
//         loggedInUser = user;
//         print(loggedInUser.email);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//     _loading = true;

//     loadModel().then((value) {
//       setState(() {
//         _loading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: null,
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.close),
//             onPressed: () {
//               _auth.signOut();
//               Navigator.pop(context);
//             }),
//         ],
//         title: 
//           Text(
//             'Capture Pothole',
//             style: TextStyle(color: Colors.white),
//           ),
//         backgroundColor: Colors.black,
//       ),
//       backgroundColor: Colors.white,
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             IconButton(
//               icon: Icon(
//                 Icons.photo_camera,
//                 size: 30,
//                 color: Colors.black
//               ),
//               onPressed: () => _pickImage(ImageSource.camera),
//               color: Colors.black,
//             ),
//             IconButton(
//               icon: Icon(
//                 Icons.photo_library,
//                 size: 30,
//                 color: Colors.grey
//               ),
//               onPressed: () => _pickImage(ImageSource.gallery),
//               color: Colors.black,
//             ),
//           ],
//         ),
//       ),
//       body: ListView(
//         children: <Widget>[
//           if (_imageFile != null) ...[
//             Container(
//                 padding: EdgeInsets.all(32), child: Image.file(_imageFile)),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 new FloatingActionButton(
//                   heroTag: 'Crop',
//                   child: Icon(Icons.crop),
//                   onPressed: _cropImage,
//                   backgroundColor: Colors.grey,
//                 ),
//                 new FloatingActionButton(
//                   heroTag: 'Refresh',
//                   child: Icon(Icons.refresh),
//                   onPressed: _clear,
//                   backgroundColor: Colors.grey,
//                 ),
//               ],
//             ),
//             if ("${_outputs[0]["index"]}" == "1") ...[
//               // RoundedButton(
//               //   title: 'Register Details', 
//               //   color: Colors.black, 
//               //   onPressed: () {
//               //     // Navigator.pushNamed(context, InformationScreen.id);
//               //     Navigator.push(
//               //       context,
//               //       MaterialPageRoute(
//               //         builder: (context) => InformationScreen(url: urlGlobal),
//               //       ));
//               //   },
//               // ),
//               Padding(
//                 padding: const EdgeInsets.all(32),
//                 child: Uploader(
//                   file: _imageFile,
//                 )
//               ),
//               Text(
//                 "Pothole Detected!",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 20.0,
//                   background: Paint()..color = Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               )
//             ]
//           ]
//         ],
//       ),
//     );
//   }
//   loadModel() async {
//     await Tflite.loadModel(
//       model: "assets/model_unquant.tflite",
//       labels: "assets/labels.txt",
//     );
//   }
//   @override
//   void dispose() {
//     Tflite.close();
//     super.dispose();
//   }
// }

// /// Widget used to handle the management of
// class Uploader extends StatefulWidget {
//   final File file;

//   Uploader({Key key, this.file}) : super(key: key);

//   createState() => _UploaderState();
// }

// class _UploaderState extends State<Uploader> {

//   final FirebaseStorage _storage =
//       FirebaseStorage(storageBucket: 'gs://pothole-reporter-app.appspot.com');
//   Future<String> urlGlobal;
//   StorageUploadTask _uploadTask;

//   Future<String> _startUpload() async{
//     String filePath = 'images/${DateTime.now()}.png';
//     // setState(() async{
//     //   _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
//     //   _uploadTask.onComplete.then((s){ 
//     //     final String url = (s.ref.getDownloadURL()).toString();
//     //     print("Location is " + url);
//     //   });  
//     // });

//     // String fileName = basename(_image.path);
//     StorageReference firebaseStorageRef = _storage.ref().child(filePath);
//     StorageUploadTask _uploadTask = firebaseStorageRef.putFile(widget.file);
//     StorageTaskSnapshot taskSnapshot = await _uploadTask.onComplete;
//     print(_uploadTask);

//     String url = (await taskSnapshot.ref.getDownloadURL());
//     print('URL Is $url');
//     // print(url.runtimeType);
//     return url;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // if(urlGlobal != "abc") { 
//     //   Text('Hello');
//     // }
//     // Text('Hello');
//     if (_uploadTask != null) {
//       // Text('data');
//       return RoundedButton(
//         title: 'Register Details', 
//         color: Colors.black, 
//         onPressed: () {
//           // Navigator.pushNamed(context, InformationScreen.id);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => InformationScreen(url: urlGlobal),
//             ));
//         },
//       );
//       // if (urlGlobal != null) {
//       // return StreamBuilder<StorageTaskEvent>(
//       //     stream: _uploadTask.events,
//       //     builder: (context, snapshot) {
//       //       var event = snapshot?.data?.snapshot;

//       //       double progressPercent = event != null
//       //           ? event.bytesTransferred / event.totalByteCount
//       //           : 0;

//       //       return Column(
//       //           mainAxisAlignment: MainAxisAlignment.center,
//       //           crossAxisAlignment: CrossAxisAlignment.center,
//       //           children: [
//       //             if (_uploadTask.isComplete)
//       //               Text('🎉🎉🎉',
//       //                 style: TextStyle(
//       //                     color: Colors.greenAccent,
//       //                     height: 2,
//       //                     fontSize: 30)
//       //               ),
//       //               RoundedButton(
//       //                 title: 'Register Details', 
//       //                 color: Colors.black, 
//       //                 onPressed: () {
//       //                   // Navigator.pushNamed(context, InformationScreen.id);
//       //                   Navigator.push(
//       //                     context,
//       //                     MaterialPageRoute(
//       //                       builder: (context) => InformationScreen(url: urlGlobal),
//       //                     ));
//       //                 },
//       //               ),
//       //             if (_uploadTask.isPaused)
//       //               FlatButton(
//       //                 child: Icon(Icons.play_arrow, size: 50),
//       //                 onPressed: _uploadTask.resume,
//       //               ),
//       //             if (_uploadTask.isInProgress)
//       //               FlatButton(
//       //                 child: Icon(Icons.pause, size: 50),
//       //                 onPressed: _uploadTask.pause,
//       //               ),

//       //             LinearProgressIndicator(value: progressPercent),
//       //             Text(
//       //               '${(progressPercent * 100).toStringAsFixed(2)} % ',
//       //               style: TextStyle(fontSize: 40),
//       //             ),      
//       //           ]);
//       //     });
//     } else {
//       return 
//           FlatButton.icon(
//           color: Colors.grey[500],
//           label: Text(
//             'Register Complaint',
//             style: TextStyle(
//               color: Colors.white
//             ),
//           ),
//           icon: Icon(Icons.cloud_upload),
//           onPressed: () {
//             // urlGlobal = _startUpload as Future<String>;
//             urlGlobal = _startUpload();
//             print(urlGlobal);
//           }
//         );
//     }
//   }
// }























