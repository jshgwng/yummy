// screens/product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:yummy/services/product_service.dart';
import '../models/product.dart';
import '../screens/edit_product_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

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
              title: Text(product.name),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProductScreen(productId: product.id),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Center(
                  child: Image.network(
                    product.imageUrl,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Price: Ugx. ${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Description:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text(product.description),
              ],
            ),
          );
        }
      },
    );
  }
}
