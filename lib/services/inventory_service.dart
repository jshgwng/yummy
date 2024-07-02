// services/inventory_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/inventory.dart';
import '../models/inventory_item.dart';
import '../models/product.dart';

class InventoryService {
  static const String _storageKey = 'inventory';

  Future<Inventory> getInventory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? inventoryJson = prefs.getString(_storageKey);
    if (inventoryJson != null) {
      return Inventory.fromJson(jsonDecode(inventoryJson));
    }
    return Inventory(items: []);
  }

  Future<void> saveInventory(Inventory inventory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(inventory.toJson()));
  }

  Future<List<InventoryItem>> getInventoryItems() async {
    Inventory inventory = await getInventory();
    return inventory.items;
  }

  Future<void> addProduct(Product product, int quantity) async {
    Inventory inventory = await getInventory();
    // Check if the product already exists in inventory
    int existingIndex = inventory.items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex != -1) {
      // If product exists, update quantity
      inventory.items[existingIndex].quantity += quantity;
    } else {
      // If product doesn't exist, add as new item
      inventory.items.add(InventoryItem(product: product, quantity: quantity));
    }
    await saveInventory(inventory);
  }

  Future<InventoryItem?> getInventoryItemById(String id) async {
    Inventory inventory = await getInventory();
    try {
      return inventory.items.firstWhere((item) => item.product.id == id);
    } catch (e) {
      return null; // Return null if not found or any error occurs
    }
  }

  Future<void> updateProductQuantity(String id, int quantity) async {
    Inventory inventory = await getInventory();
    int index = inventory.items.indexWhere((item) => item.product.id == id);
    if (index != -1) {
      inventory.items[index].quantity = quantity;
    }
    await saveInventory(inventory);
  }

  Future<void> deleteProduct(String id) async {
    Inventory inventory = await getInventory();
    inventory.items.removeWhere((item) => item.product.id == id);
    await saveInventory(inventory);
  }
}
