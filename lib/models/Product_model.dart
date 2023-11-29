import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String category;
  final String description;
  final Uint8List imageurl;
  final String price;
  final String restaurent;
  final int? quantity;

  const Product(
      {required this.id,
      required this.name,
      required this.category,
      required this.description,
      required this.imageurl,
      required this.price,
      required this.restaurent,
      this.quantity});

  Product copywith(
      {String? id,
      String? name,
      String? category,
      String? description,
      Uint8List? imageurl,
      String? price,
      int? index,
      int? quantity}) {
    return Product(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        description: description ?? this.description,
        imageurl: imageurl ?? this.imageurl,
        price: price ?? this.price,
        restaurent: restaurent ?? this.restaurent,
        quantity: quantity ?? this.quantity);
  }

  factory Product.fromSnapshot(Map<String, dynamic> snap) {
    return Product(
        id: snap['id'],
        name: snap['name'],
        category: snap['category'],
        description: snap['description'],
        imageurl: Uint8List.fromList(snap['imageurl']), // Convert to Uint8List
        price: snap['price'],
        restaurent: snap['restaurent']);
  }
  @override
  List<Object?> get props => [
        id,
        name,
        category,
        description,
        price,
        imageurl,
        // index,
      ];

  // static List<Product> products = const [
  //   Product(
  //       id: '1',
  //       name: 'chicken tikka',
  //       category: 'pizza',
  //       description: 'tomato',
  //       imageurl: "images/burger1.jpg",
  //       price: '4',
  //       index: 0),
  //   Product(
  //       id: '1',
  //       name: 'chicken tikka',
  //       category: 'pizza',
  //       description: 'tomato',
  //       imageurl: "images/burger1.jpg",
  //       price: '4',
  //       index: 1),
  //   Product(
  //       id: '1',
  //       name: 'chicken tikka',
  //       category: 'pizza',
  //       description: 'tomato',
  //       imageurl: "images/burger1.jpg",
  //       price: '4',
  //       index: 2),
  //   Product(
  //       id: '1',
  //       name: 'chicken tikka',
  //       category: 'pizza',
  //       description: 'tomato',
  //       imageurl: "images/burger1.jpg",
  //       price: '4',
  //       index: 3),
  //   Product(
  //       id: '1',
  //       name: 'chicken tikka',
  //       category: 'pizza',
  //       description: 'tomato',
  //       imageurl: "images/burger1.jpg",
  //       price: '4',
  //       index: 4),
  //   Product(
  //       id: '1',
  //       name: 'chicken tikka',
  //       category: 'pizza',
  //       description: 'tomato',
  //       imageurl: "images/burger1.jpg",
  //       price: '4',
  //       index: 5),
  // ];
}
