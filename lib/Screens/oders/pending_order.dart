import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastfoodweb/Screens/oders/order_details.dart';
import 'package:fastfoodweb/models/order_model/order_model.dart';
import 'package:fastfoodweb/provider/restaurent_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
          child: Text(
            'Pending Orders',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: StreamBuilder<List<Orders>>(
        stream:
            Provider.of<RestaurantProvider>(context).fetchPedingorder('saifu'),
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
              child: Text('No pending orders found'),
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(20.0),
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
                      leading: CircleAvatar(
                        backgroundImage: MemoryImage(
                          base64Decode(order.items[0].imagepath),
                        ),
                      ),
                      title: Text('Order ID: ${order.orderId}'),
                      subtitle: Text('Total: ${order.totalAmount}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.orange,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrderDetailPage(order: order),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.approval,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              // Handle deletion functionality
                              // You need to define the logic for deleting the order
                            },
                          ),
                        ],
                      ),
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
