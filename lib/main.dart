import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/search_screen.dart';
import 'package:my_app/screens/take_picture_screen.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  // Set orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: TakePictureScreen(
          // Pass the appropriate camera to the TakePictureScreen widget.
          camera: firstCamera,
        ),
        routes: {
          SearchScreen.routeName: (ctx) => SearchScreen(),
        },
      ),
    ),
  );
}
