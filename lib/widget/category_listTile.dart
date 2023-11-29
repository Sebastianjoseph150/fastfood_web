// import 'package:fastfoodweb/models/Product_model.dart';
// import 'package:flutter/material.dart';
// import 'package:fastfoodweb/models/category_model.dart';
// import 'package:fastfoodweb/provider/product_provider.dart';

// class CategoryListTile extends StatelessWidget {
//   const CategoryListTile({Key? key, required this.category}) : super(key: key);
//   final Category category;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Image.asset(
//         category.imageUrl,
//         height: 30,
//       ),
//       title: Text(category.name),
//       subtitle: Text(category.description),
//       trailing: const Icon(Icons.menu),
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => CategoryPage(category: category.name),
//           ),
//         );
//       },
//     );
//   }
// }

// class CategoryPage extends StatelessWidget {
//   final String category;
//   CategoryPage({required this.category});

//   @override
//   Widget build(BuildContext context) {
//     ProductProvider productProvider = ProductProvider();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(category),
//       ),
//       body: FutureBuilder<List<Product>>(
//         future: productProvider.fetchUserProductsByCategory(category),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           final List<Product>? products = snapshot.data;

//           if (products == null || products.isEmpty) {
//             return Center(
//               child: Text('No products available in this category.'),
//             );
//           }

//           return Container(
//             padding: const EdgeInsets.all(20.0),
//             color: Colors.grey[350],
//             child: ListView.builder(
//               itemCount: products.length,
//               itemBuilder: (context, index) {
//                 final Product product = products[index];
//                 return Card(
//                   elevation: 3,
//                   margin: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: ListTile(
//                     // leading:
//                     // CircleAvatar(
//                     //   backgroundImage:
//                     //       AssetImage('assets/images/${product.imageurl}'),
//                     //   // You may need to modify the path or method of accessing the image
//                     // ),
//                     title: Text(product.name),
//                     subtitle: Text(product.description),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit),
//                           onPressed: () {
//                             // Implement edit functionality here
//                             // You can navigate to an edit screen or show a dialog
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () {
//                             productProvider.deleteProduct(
//                                 product.id, product.category);
//                           },
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       // Implement onTap functionality if needed
//                     },
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:fastfoodweb/Screens/product_editing/product_edit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fastfoodweb/models/category_model.dart';
import 'package:fastfoodweb/provider/product_provider.dart';
import 'package:fastfoodweb/models/Product_model.dart';

class CategoryListTile extends StatelessWidget {
  const CategoryListTile({Key? key, required this.category}) : super(key: key);
  final Category category;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        category.imageUrl,
        height: 30,
      ),
      title: Text(category.name),
      subtitle: Text(category.description),
      trailing: const Icon(Icons.menu),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoryPage(category: category.name),
          ),
        );
      },
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String category;
  CategoryPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
            child: Text(
          category,
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            color: Colors.grey[350],
            child: StreamBuilder<List<Product>>(
              stream: productProvider.fetchUserProductsByCategory(category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final List<Product>? products = snapshot.data;

                if (products == null || products.isEmpty) {
                  return Center(
                    child: Text('No products available in this category.'),
                  );
                }

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final Product product = products[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: MemoryImage(product.imageurl),
                        ),
                        title: Text(product.name),
                        subtitle: Text(product.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductEditPage(
                                              product: product,
                                            )));
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                productProvider.deleteProduct(
                                    product.id, product.category);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          // Implement onTap functionality if needed
                        },
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
