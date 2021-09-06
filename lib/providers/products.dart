import 'package:flutter/foundation.dart';
import 'package:my_app/providers/product.dart';

// Provider class to manage Products in database

class Products extends ChangeNotifier {
  List<Product> products = [];

}