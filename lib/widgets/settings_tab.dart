// widgets/settings_tab.dart

import 'package:flutter/material.dart';
import 'package:yummy/screens/add_inventory_screen.dart';
import 'package:yummy/screens/inventory_screen.dart';
import '../screens/add_product_screen.dart'; // Import AddProductScreen

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Product'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Inventory'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InventoryScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Inventory'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddInventoryScreen()),
              );
            },
          ),
          // Add more settings options if needed
        ],
      ),
    );
  }
}
