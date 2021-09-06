import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:my_app/providers/ingredient.dart';

// Provider class to manage Ingredients in database

class Ingredients extends ChangeNotifier {
  List<Ingredient> _ingredients = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Ingredient> get ingredients {
    return [..._ingredients];
  }

  void addIngredient(Ingredient ingr) {
    _ingredients.add(ingr);
  }

}