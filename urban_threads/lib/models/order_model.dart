import 'cart_item_model.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final DateTime createdAt;
  final String status;
  final double subtotal;
  final double shipping;
  final double total;

  Order({
    required this.id,
    required this.items,
    required this.createdAt,
    required this.status,
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  int get itemCount {
    return items.fold(0, (total, item) => total + item.quantity);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'subtotal': subtotal,
      'shipping': shipping,
      'total': total,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      items: (json['items'] as List? ?? [])
          .map((item) => CartItem.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'Processing',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      shipping: (json['shipping'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}
