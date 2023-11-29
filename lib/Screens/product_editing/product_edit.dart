import 'package:fastfoodweb/models/Product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fastfoodweb/provider/product_provider.dart';

class ProductEditPage extends StatefulWidget {
  final Product product; // Pass the product to edit

  ProductEditPage({required this.product});

  @override
  _ProductEditPageState createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _category = TextEditingController();
  final _restaurant = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name.text = widget.product.name;
    _description.text = widget.product.description;
    _price.text = widget.product.price;
    _category.text = widget.product.category;
    _restaurant.text = widget.product.restaurent;
  }

  void _saveProduct(ProductProvider productProvider, BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userID = user!.uid;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      productProvider.updateProduct(
        userID,
        widget.product.id,
        imageurl: widget.product.imageurl,
        name: _name.text,
        description: _description.text,
        price: _price.text,
        category: _category.text,
        restaurent: _restaurant.text,
      );

      // Display SnackBar upon successful product update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product updated successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Close the edit screen after updating the product
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
          child: Text(
            'Edit Product',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _description,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _price,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid price';
                      }
                      double? parsedPrice = double.tryParse(value);
                      if (parsedPrice == null || parsedPrice <= 0) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _restaurant,
                    decoration: InputDecoration(
                      labelText: 'Restaurant',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a restaurant name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _category,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a category';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Consumer<ProductProvider>(
                    builder: (context, productProvider, child) {
                      return ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.orange),
                        ),
                        onPressed: () {
                          _saveProduct(productProvider, context);
                        },
                        child: Text('Save Product',
                            style: TextStyle(color: Colors.white)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
