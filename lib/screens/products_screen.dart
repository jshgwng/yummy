// screens/products_screen.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';
import '../services/product_service.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService().getProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _productsFuture = ProductService().getProducts();
    });
  }

  void _deleteProduct(String id) async {
    await ProductService().deleteProduct(id);
    _refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available'));
          } else {
            List<Product> products = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshProducts,
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey(products[index].id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteProduct(products[index].id);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(products[index].imageUrl),
                      ),
                      title: Text(products[index].name),
                      subtitle: Text(
                          'Ugx. ${products[index].price.toStringAsFixed(2)}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                                productId: products[index].id),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
