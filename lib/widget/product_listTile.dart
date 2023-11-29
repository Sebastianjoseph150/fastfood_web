import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Product_model.dart';
import '../provider/product_provider.dart'; // Import your ProductProvider class

class ProductListTile extends StatelessWidget {
  const ProductListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        final List<Product> products = productProvider.products;

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final Product product = products[index];
            return ListTile(
              // leading:
              //     // CircleAvatar(backgroundImage: NetworkImage(product.imageurl)),
              title: Text(product.name),
              subtitle: Text(product.description),
              trailing: const Icon(Icons.menu),
            );
          },
        );
      },
    );
  }
}
