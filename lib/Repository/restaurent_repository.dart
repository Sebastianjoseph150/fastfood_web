import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastfoodweb/models/order_model/order_model.dart';
import 'package:fastfoodweb/models/restaurant_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GlobalData {
  static late String currentRestaurantName;
}

class RestaurantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRestaurant(String userId, Restaurant restaurant) async {
    _firestore
        .collection('users')
        .doc(userId.toString())
        .collection('restaurants')
        .doc(restaurant.id)
        .set({
      'id': restaurant.id,
      'name': restaurant.name,
      'description': restaurant.description,
    });
  }

  Future<List<Restaurant>> getRestaurants(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('restaurants')
        .get();

    List<Restaurant> restaurants = querySnapshot.docs.map((doc) {
      return Restaurant(
        imageUrl: doc['imageUrl'],
        name: doc['name'],
        description: doc['description'],
        // Map other fields
      );
    }).toList();

    if (restaurants.isNotEmpty) {
      GlobalData.currentRestaurantName = restaurants[0].name;
    } else {
      GlobalData.currentRestaurantName = '';
    }

    return restaurants;
  }

  Future<void> updateRestaurant(
      String userId, String restaurantId, Restaurant updatedRestaurant) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('restaurants')
        .doc(restaurantId)
        .update({
      'name': updatedRestaurant.name,
      'description': updatedRestaurant.description,
      // Add more fields here if needed
    });
  }

  Future<void> deleteRestaurant(String userId, String restaurantId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('restaurants')
        .doc(restaurantId)
        .delete();
  }
  ////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///

  Future<List<Orders>> fetchOrdersByRestaurantAndStatusForAllUsers(
      String restaurantName) async {
    getRestaurants(FirebaseAuth.instance.currentUser!.uid);

    List<String> userIds = await getAllUserIds();
    List<Orders> allOrders = [];

    for (String userId in userIds) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('orders')
            .where('restaurant', isEqualTo: GlobalData.currentRestaurantName)
            .where('orderstatu', isEqualTo: 'pending order')
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final orderHistory = querySnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            // Set the document ID as the status ID
            data['orderstausid'] = doc.id;

            return Orders.fromMap(data);
          }).toList();

          print(
              'Pending orders found for restaurant $restaurantName and user $userId: $orderHistory');

          allOrders.addAll(orderHistory);
        } else {
          print(
              'No pending orders found for restaurant $restaurantName and user $userId');
        }
      } catch (e) {
        print('Failed to fetch pending orders for user $userId: $e');
      }
    }

    return allOrders;
  }

  ///////
  ///
  ///
  ///
  ///
  ///

  Future<List<Orders>> fetchdeliverdorder(String restaurantName) async {
    getRestaurants(FirebaseAuth.instance.currentUser!.uid);

    List<String> userIds = await getAllUserIds();
    List<Orders> deliverdorder = [];

    for (String userId in userIds) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('orders')
            .where('restaurant', isEqualTo: GlobalData.currentRestaurantName)
            .where('orderstatu', isEqualTo: 'order delivered')
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final orderHistory = querySnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Orders.fromMap(data);
          }).toList();

          print(
              'Pending orders found for restaurant $restaurantName and user $userId: $orderHistory');

          deliverdorder.addAll(orderHistory);
        } else {
          print(
              'No pending orders found for restaurant $restaurantName and user $userId');
        }
      } catch (e) {
        print('Failed to fetch pending orders for user $userId: $e');
      }
    }

    return deliverdorder;
  }

  Future<void> changeOrderStatusToDelivered(String orderId) async {
    try {
      final userIds = await getAllUserIds();

      for (String userId in userIds) {
        try {
          final orderRef = FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('orders')
              .doc(orderId);

          await orderRef.update({'orderstatu': 'order delivered'});

          print('Order status updated to delivered for order: $orderId');
        } catch (e) {
          print('Failed to update order status for user $userId: $e');
        }
      }
    } catch (e) {
      print('Failed to fetch user IDs: $e');
    }
  }

  Future<void> DeleteOrder(String orderId) async {
    try {
      final userIds = await getAllUserIds();

      for (String userId in userIds) {
        try {
          FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('orders')
              .doc(orderId)
              .delete();

          print('order deleted: $orderId');
        } catch (e) {
          print('Failed delete  order for user $userId: $e');
        }
      }
    } catch (e) {
      print('Failed to fetch user IDs: $e');
    }
  }

  Future<List<String>> getAllUserIds() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('users').get();

      if (querySnapshot.docs.isEmpty) {
        print('No users found');
        return [];
      } else {
        final List<String> userIds =
            querySnapshot.docs.map((doc) => doc.id).toList();
        print('User IDs found: $userIds');
        return userIds;
      }
    } catch (e) {
      throw Exception('Failed to fetch user IDs: $e');
    }
  }
}
