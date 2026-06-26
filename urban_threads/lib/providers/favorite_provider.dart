import 'package:flutter/material.dart';
import '../models/product_model.dart';

class FavoriteProvider extends ChangeNotifier {
  final Map<String, Product> _items = {};

  List<Product> get items => _items.values.toList();
  int get itemCount => _items.length;

  bool isFavorite(String productId) => _items.containsKey(productId);

  void toggleFavorite(Product product) {
    if (_items.containsKey(product.id)) {
      _items.remove(product.id);
    } else {
      _items[product.id] = product;
    }
    notifyListeners();
  }

  void removeFavorite(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
}
