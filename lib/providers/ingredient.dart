import 'package:flutter/foundation.dart';
import 'package:my_app/providers/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient extends ChangeNotifier {
  List<String> ingrList = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference ingr;

  Ingredient(this.ingrList);


}
