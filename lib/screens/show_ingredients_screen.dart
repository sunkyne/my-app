import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:my_app/widgets/ingredient_list.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ShowIngredients extends StatelessWidget {
  final String imagePath;
  List<String> listOfIngr = ['ur mom', 'ur mom', 'ur mom', 'ur mom', 'ur mom', 'ur mom', 'ur mom', 'ur mom'];
  final panelController = PanelController();

  ShowIngredients(
    this.imagePath,
    // this.listOfIngr,
  );

  @override
  Widget build(BuildContext context) {
    final panelHeightOpen = MediaQuery.of(context).size.height * .9;
    final panelHeightClosed = MediaQuery.of(context).size.height * .1;
    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Ingredients'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SlidingUpPanel(
        controller: panelController,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        minHeight: panelHeightClosed,
        maxHeight: panelHeightOpen,
        // collapsed: Container(
        //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        //   child: Column(
        //     children: [
        //       Icon(Icons.drag_handle, color: Colors.black,),
        //       Text("View Ingredients", style: TextStyle(color: Colors.black),),
        //     ],
        //   ),
        // ),
        body: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        panelBuilder: (scrollController) =>
            IngredientList(listOfIngr, scrollController, panelController),
      ),
    );
  }
}
