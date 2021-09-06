import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:my_app/screens/show_ingredients_screen.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  String processedText = "";
  List<String> listOfIngr = [];
  List<TextBlock> elements = [];
  Size imageSize = Size(0, 0);
  final scale;

  DisplayPictureScreen({Key? key, required this.imagePath, required this.scale})
      : super(key: key);

  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  void _extractIngredients(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);
    String text = recognisedText.text;
    print(recognisedText.blocks);
    String txt = "";

    for (TextBlock block in recognisedText.blocks) {
      // Checks for ingredient text block
      if (block.text.toLowerCase().contains("ingredient") ||
          block.text.toLowerCase().contains("ingredients")) {
        widget.elements.add(block);
        for (TextLine line in block.lines) {
          txt += line.text;
          // for (TextElement el in line.elements) {
          //   widget.elements.add(el);
          // }
        }
        break;
      }
    }
    // Removes "ingredient" from the block of text
    widget.processedText = txt
        .toLowerCase()
        .substring(txt.indexOf("ingredients") + "ingredients".length + 1);
    // print(widget.processedText);
    // Converts text block into a list
    widget.listOfIngr = widget.processedText.split(",");
    for (String i in widget.listOfIngr) {
      i.trim();
    }
    if (this.mounted) {
      setState(() {});
    }
    textDetector.close();
  }

  Future<void> _getImageSize(String imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    // Fetching image from path
    final Image image = Image.file(
      File(imageFile),
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
    );

    // Retrieving its size
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      widget.imageSize = imageSize;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _extractIngredients(widget.imagePath);
    _getImageSize(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    // print("Screen size : ${MediaQuery.of(context).size.width}");
    // print("Image size : ${widget.imageSize.width}");
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Confirm'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Stack(
        children: [
          CustomPaint( // An attempt to display which block of text is detected
            foregroundPainter: TextDetectorPainter(
              widget.imageSize,
              widget.elements,
              widget.scale,
            ),
            child: Transform.scale(
              scale: widget.scale,
              child: Center(
                child: Image.file(
                  File(widget.imagePath),
                ),
              ),
            ),
            // child: Image.file(File(widget.imagePath)),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Container(
          //     width: 125,
          //     height: 125,
          //     alignment: Alignment.bottomCenter,
          //     child: IconButton(
          //       onPressed: () {
          //
          //       },
          //       icon: Icon(Icons.check_circle_outlined),
          //       color: Colors.white,
          //       iconSize: 50,
          //     ),
          //   ),
          // ),
        ],
      ),
      floatingActionButton: Container(
        width: 125,
        height: 125,
        child: FittedBox(
          child: FloatingActionButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            splashColor: Colors.transparent,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            // Provide an onPressed callback.
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      ShowIngredients(
                    widget.imagePath,
                    // widget.listOfIngr,
                  ),
                  transitionDuration: Duration(seconds: 0),
                ),
              );
            },
            child: Icon(
              Icons.check_circle_outline,
              size: 50,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class TextDetectorPainter extends CustomPainter {
  final Size absoluteImageSize;
  final List<TextBlock> elements;
  final scale;

  TextDetectorPainter(
    this.absoluteImageSize,
    this.elements,
    this.scale,
  );

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;
    print("Scale : ${size.aspectRatio * absoluteImageSize.aspectRatio}");
    Rect scaleRect(Rect container) {
      print(container.left * scaleX);
      return Rect.fromLTRB(
        container.left * scaleX / scale,
        container.top * scaleY,
        container.right * scaleX * scale,
        container.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;
    for (TextBlock element in elements) {
      canvas.drawRect(scaleRect(element.rect), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
