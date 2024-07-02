// screens/edit_product_quantity_screen.dart

import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/inventory_service.dart';

class EditProductQuantityScreen extends StatefulWidget {
  final InventoryItem item;

  const EditProductQuantityScreen({super.key, required this.item});

  @override
  // ignore: library_private_types_in_public_api
  _EditProductQuantityScreenState createState() => _EditProductQuantityScreenState();
}

class _EditProductQuantityScreenState extends State<EditProductQuantityScreen> {
  final InventoryService _inventoryService = InventoryService();
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: widget.item.quantity.toString());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Quantity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product: ${widget.item.product.name}'),
            const SizedBox(height: 16.0),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                int newQuantity = int.tryParse(_quantityController.text) ?? 0;
                await _inventoryService.updateProductQuantity(widget.item.product.id, newQuantity);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
