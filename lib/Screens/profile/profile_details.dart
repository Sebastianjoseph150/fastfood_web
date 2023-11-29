import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastfoodweb/Screens/profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileDetailsPage extends StatefulWidget {
  @override
  _ProfileDetailsPageState createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String userId = _user!.uid;
    final restaurantDetails = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('restaurants')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Profile Details'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: restaurantDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No restaurants found'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()));
                    },
                    child: const Text('Add Restaurant Details'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Complete your profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Functionality to complete profile
                      // Implement navigation or actions to complete the profile
                      // Navigator.push(...);
                    },
                    child: const Text('Complete Profile'),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 500,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final name = snapshot.data!.docs[index]['name'];
                    final description =
                        snapshot.data!.docs[index]['description'];
                    final image = snapshot.data!.docs[index]['imageUrl'];

                    return GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Edit Details'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Close'),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      // child: Card(
                      //   elevation: 5,
                      child: Container(
                        height: 500,
                        width: 300,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: [
                              Container(
                                width: 200,
                                height: 200,
                                child: Icon(Icons.restaurant, size: 100),
                                // child: Image.network(''),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: 200,
                                height: 30,
                                decoration: BoxDecoration(
                                  // border: Border.all(
                                  //   color: Colors.black,
                                  //   width: 2.0,
                                  // ),
                                  borderRadius: BorderRadius.circular(4.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: Center(child: Text(name)),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: 200,
                                height: 30,
                                decoration: BoxDecoration(
                                  // border: Border.all(
                                  //   color: Colors.black,
                                  //   width: 2.0,
                                  // ),
                                  borderRadius: BorderRadius.circular(4.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: Center(child: Text(description)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
