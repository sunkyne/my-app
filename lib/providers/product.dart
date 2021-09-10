import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:my_app/providers/ingredient.dart';

class Product extends ChangeNotifier {
  final String imagePath;
  final String name;
  List<String> _ingr = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference prod;

  Product(this._ingr,{this.imagePath = "", this.name = ""}) {
    prod = firestore.collection('products').doc(name).collection('ingr_list');
    _ingr.forEach((element) {
      prod.add({'id':element});
    });
  }

  List<String> get ingr {
    return [..._ingr];
  }

  Future<void> addProdToIngr() async {
    var collectionRef = firestore.collection('ingredients');
    _ingr.forEach((element) async {
      collectionRef.doc(element).collection('prod_list').add({'id':name});
    });
  }

  void addIngrToProd(String ingr) {
    _ingr.add(ingr);
    prod.add({'id':ingr});
  }

}