import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0;
    for (var item in _items) {
      total += item.subtotal;
    }
    return total;
  }

  void addItem(Product product, {String color = '', String size = ''}) {
    final existingIndex = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedColor == color &&
          item.selectedSize == size,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(
        CartItem(
          product: product,
          selectedColor: color,
          selectedSize: size,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void removeCartItem(CartItem cartItem) {
    _items.removeWhere((item) => _isSameCartItem(item, cartItem));
    notifyListeners();
  }

  void removeItems(List<CartItem> cartItems) {
    _items.removeWhere(
      (item) => cartItems.any((cartItem) => _isSameCartItem(item, cartItem)),
    );
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void updateCartItemQuantity(CartItem cartItem, int newQuantity) {
    final index = _items.indexWhere((item) => _isSameCartItem(item, cartItem));
    if (index >= 0) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool _isSameCartItem(CartItem first, CartItem second) {
    return first.product.id == second.product.id &&
        first.selectedColor == second.selectedColor &&
        first.selectedSize == second.selectedSize;
  }
}
