import 'dart:convert';
import 'dart:typed_data';

import 'package:fastfoodweb/Screens/product_editing/product_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/add_ product.dart';
import '../models/Product_model.dart';
import '../provider/product_provider.dart';

class productListing extends StatelessWidget {
  const productListing({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        User? user = FirebaseAuth.instance.currentUser;
        String userid = user!.uid;
        if (productProvider.products.isNotEmpty) {
          print(productProvider.products.length);
          return SizedBox(
            width: double.infinity,
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: productProvider.products.length,
              itemBuilder: (BuildContext context, int index) {
                return ProductCard(
                  product: productProvider.products[index],
                  index: index,
                );
              },
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final int index;

  const ProductCard({
    required this.product,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductEditPage(product: product),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: MemoryImage(product.imageurl),
              ),
              Text(product.name),
              Text('\n₹${product.price}'),
            ],
          ),
        ),
      ),
    );
  }
}
// class ProductCard extends StatelessWidget {
//   final Product product;
//   final int index;

//   const ProductCard({
//     required this.product,
//     required this.index,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (index == 0) {
//      //Adding card
//       return Padding(
//         padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
//         child: Container(
//           width: 150,
//           margin: const EdgeInsets.only(right: 20),
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ProductAddingPage(),
//                     ),
//                   );
//                 },
//                 icon: Icon(Icons.add_circle),
//               ),
//               const Text('Add a product'),
//             ],
//           ),
//         ),
//       );
//     } else {
//       // product card
//       return Padding(
//         padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
//         child: Container(
//           width: 150,
//           margin: const EdgeInsets.only(right: 20),
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//           child: InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ProductEditPage(product: product),
//                 ),
//               );
//             },
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 CircleAvatar(
//                   radius: 40,
//                   backgroundImage: MemoryImage(product.imageurl),
//                 ),
//                 Text(product.name),
//                 Text('\$${product.price}'),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//   }
// }


// improtant taken from menu screen
 // Consumer<ProductProvider>(
                  //   builder: (context, productProvider, child) {
                  //     User? user = FirebaseAuth.instance.currentUser;
                  //     String userid = user!.uid;
                  //     productProvider.fetchProductsForUser(userid);
                  //     if (productProvider.fproducts.isNotEmpty) {
                  //       print(productProvider.fproducts.length);
                  //       return SizedBox(
                  //         width: double.infinity,
                  //         height: 200,
                  //         child: ListView.builder(
                  //           shrinkWrap: true,
                  //           scrollDirection: Axis.horizontal,
                  //           itemCount: productProvider.fproducts.length,
                  //           itemBuilder: (BuildContext context, int index) {
                  //             return ProductCard(
                  //               product: productProvider.fproducts[index],
                  //               index: index,
                  //             );
                  //           },
                  //         ),
                  //       );
                  //       // Display a loading indicator
                  //     } else {
                  //       // return const CircularProgressIndicator();
                  //       return const Text('No products available');
                  //     }
                  //   },
                  // ),