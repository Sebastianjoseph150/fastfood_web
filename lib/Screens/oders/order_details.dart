// ignore_for_file: prefer_const_constructors

import 'package:fastfoodweb/Screens/oders/pending_order.dart';
import 'package:fastfoodweb/models/order_model/order_model.dart';
import 'package:fastfoodweb/provider/restaurent_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatelessWidget {
  final Orders order;

  const OrderDetailPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
          child: Text(
            'Order Details',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: 500,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 203, 203, 203),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: ${order.orderId}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Address:\n${order.address.name}\n${order.address.street}\n${order.address.city}\n${order.address.postalCode}',
                ),
                SizedBox(height: 20),
                Text(
                  'Items:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: order.items.length,
                    itemBuilder: (context, index) {
                      final item = order.items[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Item ${index + 1}:'),
                          Text('Description: ${item.description}'),
                          Text('Price: ${item.price}'),
                          Text('Quantity: ${item.quantity}'),
                          SizedBox(height: 10),
                          Divider(), // Add a divider between items
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Text('Total: ${order.totalAmount}'),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<RestaurantProvider>(context, listen: false)
                            .changeOrderStatus(order.orderstausid);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderListWidget()));
                      },
                      child: Text('Approve',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<RestaurantProvider>(context, listen: false)
                            .DeleteOrder(order.orderstausid);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderListWidget()));
                      },
                      child:
                          Text('Reject', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red, // Set button background color
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
