import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastfoodweb/models/Product_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];
  List<String> categories = [
    'veg items',
    'non-veg items',
    'bread items',
    'main courses',
    'starters',
    'burger',
    'pizza'
  ];
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('foodItems');
  Uint8List? _pickedImage;
  Uint8List? get pickedImage => _pickedImage;

  List<Product> get products => _products;

  Future<String> addProductToFirestore({
    required String userID,
    required String name,
    required String price,
    required String description,
    required String category,
    required Uint8List imageUrl,
    required String restaurant,
    required int quantity,
  }) async {
    try {
      String base64Image = base64Encode(imageUrl);

      ;

// Get a reference to the "foodItems" collection
      final foodItemsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection(category);

      DocumentReference docRef = await foodItemsCollection.add({
        'name': name,
        'price': price,
        'description': description,
        'category': category,
        'imageUrl': base64Image,
        'restaurant': restaurant,
        'quantity': quantity,
      });

// Return the ID of the newly added document
      return docRef.id;
    } catch (e) {
// Return 'failed' if an error occurs
      print('Error adding product: $e');
      return 'failed';
    }
  }

  Future<void> pickImage() async {
    try {
      final FilePickerResult? pickedImage =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (pickedImage != null &&
          pickedImage.files.isNotEmpty &&
          pickedImage.files.first.bytes != null) {
        final fileBytes = pickedImage.files.first.bytes!;
        _pickedImage = Uint8List.fromList(fileBytes);
      } else {
        // Handle the case when pickedImage or its bytes are null
        print('Picked image or its bytes are null.');
        _pickedImage = Uint8List(0); // Initialize with an empty Uint8List
      }
    } catch (e) {
      print('Error picking image: $e');
      _pickedImage =
          Uint8List(0); // Handle error by initializing with empty Uint8List
    }
    notifyListeners();
  }

  Future<List<Product>> fetchProductsForUser(String userID) async {
    try {
      _products.clear();

      for (String category in categories) {
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .collection(category)
            .get();

        for (final QueryDocumentSnapshot document in querySnapshot.docs) {
          final Map<String, dynamic> data =
              document.data() as Map<String, dynamic>;

          String base64Image = data['imageUrl'];
          Uint8List imageBytes = Uint8List.fromList(base64Decode(base64Image));

          Product product = Product(
            id: document.id,
            name: data['name'],
            price: data['price'],
            description: data['description'],
            category: data['category'],
            imageurl: imageBytes,
            restaurent: data['restaurant'],
          );

          _products.add(product);
          // debugPrint(_products.toString());
        }
        notifyListeners();
      }

      return products;
    } catch (e) {
      print('Error fetching products: $e');
      throw e; // You can also throw the error to handle it at the calling code
    }
  }

  Future<void> updateProduct(String userID, String productId,
      {required String name,
      required String description,
      required String price,
      required String category,
      required Uint8List imageurl,
      required String restaurent}) async {
    final productIndex =
        products.indexWhere((product) => product.id == productId);

    if (productIndex != -1) {
      products[productIndex] = Product(
          id: productId,
          name: name,
          imageurl: imageurl,
          description: description,
          price: price,
          category: category,
          restaurent: restaurent);

      await updateProductInFirestore(
          userID, productId, name, description, price, category, restaurent);

      notifyListeners();
    }
  }

  Future<void> updateProductInFirestore(
      String userID,
      String productId,
      String name,
      String description,
      String price,
      String category,
      String restaurent) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection(category)
          .doc(productId)
          .update({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'restaurent': restaurent,
      });
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(String productId, String category) async {
    print('Hii');
    print(productId);
    final user = FirebaseAuth.instance.currentUser;
    final userid = user!.uid;
    try {
      // Delete the product from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .collection(category)
          .doc(productId)
          .delete();

      _products.removeWhere((product) => product.id == productId);
      notifyListeners();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  Stream<List<Product>> fetchUserProductsByCategory(
    String category,
  ) async* {
    final user = FirebaseAuth.instance.currentUser;
    final userid = user!.uid;
    try {
      final List<Product> categoryProducts = [];
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .collection(category)
          .get();

      for (final QueryDocumentSnapshot document in querySnapshot.docs) {
        final Map<String, dynamic> data =
            document.data() as Map<String, dynamic>;

        String base64Image = data['imageUrl'];
        Uint8List imageBytes = Uint8List.fromList(base64Decode(base64Image));

        Product product = Product(
          id: document.id,
          name: data['name'],
          price: data['price'],
          description: data['description'],
          category: data['category'],
          imageurl: imageBytes,
          restaurent: data['restaurent'],
        );

        categoryProducts.add(product);
      }
      yield categoryProducts;
    } catch (e) {
      print('Error fetching user products by category: $e');
      throw e;
    }
  }
}

//   }
// }