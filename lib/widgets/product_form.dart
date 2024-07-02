// widgets/product_form.dart

import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductForm extends StatefulWidget {
  final Product? product; // Null when adding a new product
  final Function(Product) onSave; // Callback to save the product

  const ProductForm({super.key, this.product, required this.onSave});

  @override
  // ignore: library_private_types_in_public_api
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _imageUrlController = TextEditingController(text: widget.product?.imageUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Product newProduct = Product(
        id: widget.product?.id ?? DateTime.now().toString(), // Use existing ID or generate new one
        name: _nameController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
      );

      widget.onSave(newProduct);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Product Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a product name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: 'Price'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a price';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
          TextFormField(
            controller: _imageUrlController,
            decoration: const InputDecoration(labelText: 'Image URL'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an image URL';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(widget.product == null ? 'Add Product' : 'Update Product'),
          ),
        ],
      ),
    );
  }
}
