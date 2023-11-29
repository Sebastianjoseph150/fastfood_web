import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastfoodweb/models/order_model/order_model.dart';
import 'package:fastfoodweb/provider/restaurent_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeliverdOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(child: Text('delivered order')),
      ),
      body: StreamBuilder<List<Orders>>(
        stream: Provider.of<RestaurantProvider>(context)
            .fetchdeliverdorder('saifu'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No deliverd pending orders found'),
            );
          } else {
            return Container(
              color: Colors.grey[350],
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final order = snapshot.data![index];
                  return Card(
                    elevation: 4, // Set the elevation for the card
                    margin: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16), // Adjust margins as needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12), // Set border radius for the card
                    ),
                    child: ListTile(
                      title: Text('${index + 1}. Order ID: ${order.orderId}'),
                      subtitle: Text('Total: ${order.totalAmount}'),
                      // Add more order details you want to display in the list
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
