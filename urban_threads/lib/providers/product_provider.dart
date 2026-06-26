import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _allProducts;
  List<Product> get featuredProducts =>
      _allProducts.where((p) => p.isFeatured).toList();
  List<Product> get newArrivals => _allProducts.where((p) => p.isNew).toList();
  String get selectedCategory => _selectedCategory;

  int countForCategory(String category) {
    if (category == 'All') {
      return _allProducts.length;
    }
    return _allProducts.where((product) => product.category == category).length;
  }

  Future<void> loadProducts() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> data = json.decode(response);

      _allProducts = data.map((json) => Product.fromJson(json)).toList();
      _filteredProducts = _allProducts;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading products: $e');
    }
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void searchProducts(String query) {
    _searchQuery = query.toLowerCase().trim();
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      // Category filter
      bool categoryMatch =
          _selectedCategory == 'All' || product.category == _selectedCategory;

      // Search filter
      final searchMatch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery) ||
          product.description.toLowerCase().contains(_searchQuery) ||
          (product.brand != null &&
              product.brand!.toLowerCase().contains(_searchQuery));

      return categoryMatch && searchMatch;
    }).toList();

    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  List<String> get categories {
    Set<String> cats = {'All'};
    for (var product in _allProducts) {
      cats.add(product.category);
    }
    return cats.toList();
  }
}
