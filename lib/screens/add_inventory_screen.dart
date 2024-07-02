import 'package:flutter/material.dart';
import 'package:yummy/models/inventory.dart';
import 'package:yummy/services/product_service.dart';
import '../models/product.dart'; // Adjust the import path based on your project structure
import '../models/inventory_item.dart';
import '../services/inventory_service.dart';

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddInventoryScreenState createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  final InventoryService _inventoryService = InventoryService();
  final ProductService _productService = ProductService();
  List<Product> _availableProducts = [];
  late Product _selectedProduct;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _quantityController = TextEditingController();
  }

  void _loadProducts() async {
    List<Product> products = await _productService.getProducts();
    setState(() {
      _availableProducts = products;
      _selectedProduct = _availableProducts.first;
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _addInventory() {
    int quantity = int.tryParse(_quantityController.text) ?? 0;
    _inventoryService.saveInventory(Inventory(items: [
      InventoryItem(
        product: _selectedProduct,
        quantity: quantity,
      )
    ]));
    Navigator.pop(context); // Return to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Inventory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<Product>(
              value: _selectedProduct,
              items: _availableProducts.map((product) {
                return DropdownMenuItem<Product>(
                  value: product,
                  child: Text(product.name),
                );
              }).toList(),
              onChanged: (Product? value) {
                setState(() {
                  _selectedProduct = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Product',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addInventory,
              child: const Text('Add Inventory'),
            ),
          ],
        ),
      ),
    );
  }
}
