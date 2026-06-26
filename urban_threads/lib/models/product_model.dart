class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int reviews;
  final String imageUrl;
  final List<String> colors;
  final List<String> sizes;
  final String category;
  final bool isNew;
  final bool isFeatured;
  final String? brand;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.colors,
    required this.sizes,
    required this.category,
    this.isNew = false,
    this.isFeatured = false,
    this.brand,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      colors: List<String>.from(json['colors'] ?? []),
      sizes: List<String>.from(json['sizes'] ?? []),
      category: json['category'] ?? '',
      isNew: json['isNew'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      brand: json['brand'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'rating': rating,
      'reviews': reviews,
      'imageUrl': imageUrl,
      'colors': colors,
      'sizes': sizes,
      'category': category,
      'isNew': isNew,
      'isFeatured': isFeatured,
      'brand': brand,
    };
  }
}
