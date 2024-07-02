import 'product.dart';

class InventoryItem {
  Product product;
  int quantity;

  InventoryItem({
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}
