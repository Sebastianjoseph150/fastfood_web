// import 'dart:html';

import 'package:fastfoodweb/Screens/add_%20product.dart';
import 'package:fastfoodweb/Screens/auth/admin_login.dart';
import 'package:fastfoodweb/Screens/oders/delivered_order.dart';
import 'package:fastfoodweb/Screens/oders/pending_order.dart';
import 'package:fastfoodweb/Screens/profile/profile_details.dart';
import 'package:fastfoodweb/models/category_model.dart';
import 'package:fastfoodweb/provider/product_provider.dart';
import 'package:fastfoodweb/provider/restaurent_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/responsive.dart';
import '../widget/category_listTile.dart';
import '../widget/product_card.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({Key? key}) : super(key: key);

  final ProductProvider productProvider = ProductProvider();
  final RestaurantProvider restaurantProvider = RestaurantProvider();
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print(user);
      String userID = user.uid;

      Provider.of<ProductProvider>(context, listen: false)
          .fetchProductsForUser(userID);
      print(productProvider.products.length);
    }
    // productProvider.fetchProductsForUser(userID)
    // Call the fetchProductData function after the first frame is built
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fast Food',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber[600],
        centerTitle: false,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 65.0,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.amber[500],
                ),
                child: const Text('Fast Food'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('profile'),
              onTap: () {
                restaurantProvider.fetchRestaurants(user!.uid.toString());
                // print(restaurantProvider.restaurantrestult);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileDetailsPage()));
                //
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('pending orders'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderListWidget()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('deliverd orders'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DeliverdOrder()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop(); // Close the dialog
                            final auth = FirebaseAuth.instance;
                            await auth.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AdminLoginPage(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: const Text('Sign Out'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductAddingPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_circle),
                      ),
                      const Text('Add a product'),
                    ],
                  ),
                  const Text('Restaurant menu'),
                  const SizedBox(height: 20),
                  const productListing(),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      constraints: const BoxConstraints(
                        minHeight: 300,
                        maxHeight: 1000,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildcategory(),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          // Expanded(
                          //   child: _buildproduct(),
                          // )
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 75),
                    color: Colors.orange[300],
                    child: const Center(
                      child: Text('some ads'),
                    ),
                  )
                ],
              ),
            ),
          ),
          Responsive.isWideDesktop(context) || Responsive.isDesktop(context)
              ? Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 20,
                      right: 20,
                    ),
                    child: const Text('Some ads here'),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Container _buildcategory() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.grey[350],
      child: Column(
        children: [
          const Text('categories'),
          const SizedBox(
            height: 20,
          ),
          ...Category.categories.map((category) {
            return CategoryListTile(category: category);
          })
        ],
      ),
    );
  }
}
