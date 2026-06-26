import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  String selectedColor;
  String selectedSize;

  CartItem({
    required this.product,
    this.quantity = 1,
    required this.selectedColor,
    required this.selectedSize,
  });

  double get subtotal => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
      selectedColor: json['selectedColor'] ?? '',
      selectedSize: json['selectedSize'] ?? '',
    );
  }
}
