// services/product_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductService {
  static const String _productsKey = 'products';

  Future<void> addProduct(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    List<Product> products = await getProducts();
    products.add(product);
    await prefs.setString(_productsKey, jsonEncode(products.map((p) => p.toMap()).toList()));
  }

  Future<List<Product>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    String? productsString = prefs.getString(_productsKey);
    if (productsString != null) {
      List<dynamic> productsList = jsonDecode(productsString);
      return productsList.map((p) => Product.fromMap(p)).toList();
    } else {
      return [];
    }
  }

  Future<void> updateProduct(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    List<Product> products = await getProducts();
    int index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index] = product;
      await prefs.setString(_productsKey, jsonEncode(products.map((p) => p.toMap()).toList()));
    }
  }

  Future<void> deleteProduct(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<Product> products = await getProducts();
    products.removeWhere((p) => p.id == productId);
    await prefs.setString(_productsKey, jsonEncode(products.map((p) => p.toMap()).toList()));
  }

  Future<Product?> getProductById(String productId) async {
    List<Product> products = await getProducts();
    try {
      return products.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null; // Explicitly return null if product is not found
    }
  }
}
