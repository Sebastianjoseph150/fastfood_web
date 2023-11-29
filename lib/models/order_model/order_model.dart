import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fastfoodweb/models/address_model/address_model.dart';
import 'package:fastfoodweb/models/cart_model/cart_model.dart';

class Orders {
  final String orderId;
  final String userId;
  final Address address;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final int quantity; // Changed to int
  final String restaurant;
  final String orderstatu;
  final String orderstausid;

  Orders({
    required this.orderstausid,
    required this.orderId,
    required this.userId,
    required this.address,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.quantity,
    required this.restaurant,
    required this.orderstatu,
  });

  factory Orders.fromMap(Map<String, dynamic> map) {
    return Orders(
      orderId: map['orderId'],
      userId: map['userId'],
      address: Address.fromMap(map['address']), // Address is a single object
      items: (map['items'] as List<dynamic>)
          .map((itemMap) => CartItem.fromMap(itemMap))
          .toList(),
      totalAmount: map['totalAmount'],
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      quantity: map['quantity'] as int, // Parsing quantity as int
      restaurant: map['restaurant'],
      orderstatu: map['orderstatu'],
      orderstausid: map['orderstausid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'address': address.toMap(), // Storing Address as a Map
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'quantity': quantity,
      'restaurant': restaurant,
      'orderstatu': orderstatu,
      'orderstausid': orderstausid
    };
  }
}
