import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/files_screen.dart';
import 'package:my_app/screens/take_picture_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _controller = PageController(
    initialPage: 1,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        FilesScreen(),
        TakePictureScreen(camera: widget.camera),
      ],
    );
  }
}