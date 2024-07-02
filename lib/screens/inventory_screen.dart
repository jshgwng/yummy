import 'package:flutter/material.dart';
import 'package:yummy/models/cart_item.dart';
import '../models/inventory_item.dart';
import '../services/inventory_service.dart';
import '../services/cart_service.dart';
import 'shopping_cart_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final InventoryService _inventoryService = InventoryService();
  final CartService _cartService = CartService();

  late Future<List<InventoryItem>> _inventoryItemsFuture;

  @override
  void initState() {
    super.initState();
    _loadInventoryItems();
  }

  Future<void> _loadInventoryItems() async {
    setState(() {
      _inventoryItemsFuture = _inventoryService.getInventoryItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShoppingCartScreen(),
                ),
              ).then((_) {
                // Refresh inventory list if needed after returning from shopping cart
                _loadInventoryItems();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<InventoryItem>>(
        future: _inventoryItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No inventory items found.'));
          } else {
            List<InventoryItem> items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                InventoryItem item = items[index];
                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () async {
                      // Add item to cart
                      await _cartService.addToCart(
                        CartItem(
                          product: item.product,
                          quantity: 1, // You can modify quantity if needed
                        ),
                      );
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Item added to cart'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
