// screens/edit_product_screen.dart

import 'package:flutter/material.dart';
import '../widgets/product_form.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class EditProductScreen extends StatelessWidget {
  final String productId;

  const EditProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product?>(
      future: ProductService().getProductById(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Product not found'));
        } else {
          Product product = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Product'),
            ),
            body: ProductForm(
              product: product,
              onSave: (updatedProduct) {
                ProductService().updateProduct(updatedProduct);
              },
            ),
          );
        }
      },
    );
  }
}
