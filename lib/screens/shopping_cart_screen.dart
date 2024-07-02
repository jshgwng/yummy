import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  CartService _cartService = CartService();
  late List<CartItem> _cartItems;
  late double _totalPrice;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    List<CartItem> cartItems = await _cartService.getCartItems();
    double totalPrice = await _cartService.calculateTotal();
    setState(() {
      _cartItems = cartItems;
      _totalPrice = totalPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: _cartItems.isEmpty
          ? Center(child: Text('Your shopping cart is empty.'))
          : ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                CartItem item = _cartItems[index];
                return ListTile(
                  leading: Image.network(item.product.imageUrl),
                  title: Text(item.product.name),
                  subtitle: Text('Price: \$${item.product.price} | Quantity: ${item.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () async {
                          await _cartService.updateCartItemQuantity(item.product.id, item.quantity - 1);
                          _loadCartItems();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          await _cartService.updateCartItemQuantity(item.product.id, item.quantity + 1);
                          _loadCartItems();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: \$$_totalPrice'),
              ElevatedButton(
                onPressed: () {
                  // Implement checkout functionality
                },
                child: Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
