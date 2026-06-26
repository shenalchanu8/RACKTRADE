import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item_model.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  static const String _ordersKey = 'orderHistory';

  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  OrderProvider() {
    loadOrders();
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedOrders = prefs.getStringList(_ordersKey) ?? [];

    _orders
      ..clear()
      ..addAll(
        encodedOrders.map(
          (order) => Order.fromJson(jsonDecode(order) as Map<String, dynamic>),
        ),
      );
    notifyListeners();
  }

  Future<Order> addOrder({
    required List<CartItem> items,
    double shipping = 6.00,
  }) async {
    final copiedItems = items
        .map(
          (item) => CartItem.fromJson(
            Map<String, dynamic>.from(item.toJson()),
          ),
        )
        .toList();
    final subtotal = copiedItems.fold<double>(
      0,
      (total, item) => total + item.subtotal,
    );
    final now = DateTime.now();
    final order = Order(
      id: _buildOrderId(now),
      items: copiedItems,
      createdAt: now,
      status: 'Processing',
      subtotal: subtotal,
      shipping: shipping,
      total: subtotal + shipping,
    );

    _orders.insert(0, order);
    await _saveOrders();
    notifyListeners();
    return order;
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _ordersKey,
      _orders.map((order) => jsonEncode(order.toJson())).toList(),
    );
  }

  String _buildOrderId(DateTime dateTime) {
    return 'ORD-${dateTime.millisecondsSinceEpoch}';
  }
}
