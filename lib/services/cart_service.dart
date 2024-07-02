// services/cart_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';

class CartService {
  static const String _storageKey = 'cart';

  Future<List<CartItem>> getCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartJson = prefs.getString(_storageKey);
    if (cartJson != null) {
      List<dynamic> jsonList = jsonDecode(cartJson);
      return jsonList.map((item) => CartItem.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> addToCart(CartItem newItem) async {
    List<CartItem> currentItems = await getCartItems();
    int index = currentItems.indexWhere((item) => item.product.id == newItem.product.id);

    if (index != -1) {
      // Product already exists in cart, update quantity
      currentItems[index].quantity += newItem.quantity;
    } else {
      // Product does not exist in cart, add as new item
      currentItems.add(newItem);
    }

    await saveCartItems(currentItems);
  }

  Future<void> removeFromCart(String productId) async {
    List<CartItem> currentItems = await getCartItems();
    currentItems.removeWhere((item) => item.product.id == productId);
    await saveCartItems(currentItems);
  }

  Future<void> updateCartItemQuantity(String productId, int newQuantity) async {
    List<CartItem> currentItems = await getCartItems();
    int index = currentItems.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      currentItems[index].quantity = newQuantity;
      await saveCartItems(currentItems);
    }
  }

  Future<void> clearCart() async {
    await saveCartItems([]);
  }

  Future<void> saveCartItems(List<CartItem> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartJson = jsonEncode(items.map((item) => item.toJson()).toList());
    await prefs.setString(_storageKey, cartJson);
  }

  Future<double> calculateTotal() async {
    List<CartItem> items = await getCartItems();
    double total = items.fold(0, (sum, item) => sum + item.totalPrice);
    return total;
  }
}
