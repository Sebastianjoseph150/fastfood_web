import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastfoodweb/Repository/restaurent_repository.dart';
import 'package:fastfoodweb/models/order_model/order_model.dart';
import 'package:fastfoodweb/models/restaurant_model.dart';
import 'package:flutter/material.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantRepository _restaurantRepository = RestaurantRepository();
  List<Restaurant> restaurantrestult = [];

  Future<void> fetchRestaurants(String userId) async {
    List<Restaurant> restaurants =
        await _restaurantRepository.getRestaurants(userId);
    restaurantrestult.addAll(restaurants);
    print(restaurantrestult); // Use addAll to add all elements
    notifyListeners();
  }

  void addRestaurant(String userId, Restaurant restaurant) {
    _restaurantRepository.addRestaurant(userId, restaurant);
  }

  Stream<List<Orders>> fetchPedingorder(String resturant) async* {
    final List<Orders> order = await _restaurantRepository
        .fetchOrdersByRestaurantAndStatusForAllUsers(resturant);
    yield order;
  }

  Stream<List<Orders>> fetchdeliverdorder(String resturant) async* {
    final List<Orders> deliverdorder =
        await _restaurantRepository.fetchdeliverdorder(resturant);
    yield deliverdorder;
  }

  Future<void> changeOrderStatus(String orderId) async {
    await _restaurantRepository.changeOrderStatusToDelivered(orderId);
    // You can perform any other actions or notify listeners if needed
    notifyListeners();
  }

  Future<void> DeleteOrder(String orderId) async {
    await _restaurantRepository.DeleteOrder(orderId);
    // You can perform any other actions or notify listeners if needed
    notifyListeners();
  }
}
