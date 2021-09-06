import 'package:flutter/foundation.dart';
import 'package:my_app/providers/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient extends ChangeNotifier {
  final String name;
  List<String> prodID = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference ingr;

  Ingredient(this.name) {
    ingr = firestore.collection('ingredients').doc(name).collection('prod_list');
    prodID.forEach((element) {
      ingr.add({'id':element});
    });
  }

  void addProduct(String prod) {
    prodID.add(prod);
    ingr.add({'id':prod});
  }
}
