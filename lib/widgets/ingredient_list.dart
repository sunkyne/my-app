import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/providers/product.dart';
import 'package:my_app/screens/search_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class IngredientList extends StatefulWidget {
  final List<String> listOfIngr;

  final ScrollController scrollController;
  final PanelController panelController;

  String prodTitle = "";

  IngredientList(this.listOfIngr, this.scrollController, this.panelController);

  _IngredientListState createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {
  final form = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();
  TextEditingController ingrController = TextEditingController();

  void submitProduct() {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return;
    }
    form.currentState!.save();
    //Add product and ingredients to database
    widget.listOfIngr.removeWhere((element) => element.isEmpty);
    Product(widget.listOfIngr, name: widget.prodTitle).addProdToIngr();
    Navigator.of(context).pop();
  }

  void addIngr() {
    setState(() {
      widget.listOfIngr.add("");
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        buildDragHandle(),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: form,
            child: TextFormField(
              controller: textController,
              decoration: InputDecoration(
                labelText: "Product Name",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide a product name.';
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                widget.prodTitle = value!;
                // print(widget.prodTitle);
              },
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: widget.listOfIngr.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(0),
                  controller: widget.scrollController,
                  itemCount: widget.listOfIngr.length + 1,
                  itemBuilder: (ctx, i) {
                    if (i == widget.listOfIngr.length)
                      return Card(
                        child: TextButton(
                          onPressed: addIngr,
                          style: TextButton.styleFrom(primary: Colors.grey),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add),
                              Text(
                                "Add ingredient",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    else
                      return buildIngrCard(i);
                  },
                ),
        ),
        SizedBox(
          height: 20,
        ),
        IconButton(
          onPressed: submitProduct,
          icon: Icon(Icons.add),
        ),
      ],
    );
  }

  Widget buildDragHandle() => GestureDetector(
        child: Center(
          child: Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        onTap: togglePanel,
      );

  void togglePanel() => widget.panelController.isPanelOpen
      ? widget.panelController.close()
      : widget.panelController.open();

  Widget buildIngrCard(int i) {
    ingrController = TextEditingController(text: widget.listOfIngr[i]);
    return Card(
      child: ListTile(
        title: TextField(
          controller: ingrController,
          decoration: null,
          autocorrect: true,
          autofocus: widget.listOfIngr[i].isEmpty ? true : false,
          onSubmitted: (value) {
            widget.listOfIngr[i] = value;
          },
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  SearchScreen.routeName,
                  arguments: widget.listOfIngr[i],
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showConfirmDeletion(context, i);
              },
            ),
          ],
        ),
      ),
    );
  }

  showConfirmDeletion(BuildContext context, int i) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Delete"),
      onPressed: () {
        setState(() {
          widget.listOfIngr.remove(widget.listOfIngr[i]);
        });
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      title: Text("Confirm"),
      content: Text("Are you sure you want to delete this ingredient?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
