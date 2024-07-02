// screens/add_product_screen.dart

import 'package:flutter/material.dart';
import '../widgets/product_form.dart';
import '../services/product_service.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: ProductForm(
        onSave: (product) {
          ProductService().addProduct(product);
        },
      ),
    );
  }
}
