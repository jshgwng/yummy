// models/inventory.dart

import 'inventory_item.dart';

class Inventory {
  List<InventoryItem> items;

  Inventory({required this.items});

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      items: (json['items'] as List).map((item) => InventoryItem.fromJson(item)).toList(),
    );
  }
}
