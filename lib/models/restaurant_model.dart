import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String? id;
  final String name;
  final String imageUrl;
  final String description;

  // final double deliveryFee;
  // final double distance;
  // final Place address;

  const Restaurant({
    this.id,
    required this.name,
    required this.description,
    required this.imageUrl,

    // required this.address,
    // this.deliveryTime = 10,
    // this.priceCategory = '\$',
    // this.deliveryFee = 10,
    // this.distance = 15,
  });

  factory Restaurant.fromSnapshot(DocumentSnapshot snap) {
    return Restaurant(
        id: snap.id,
        name: snap['name'],
        imageUrl: snap['imageUrl'],
        description: snap['description']
        //   tags: (snap['tags'] as List).map(
        //     (tag) {
        //       return tag as String;
        //     },
        //   ).toList(),
        //   categories: (snap['categories'] as List).map(
        //     (category) {
        //       return Category.fromSnapshot(category);
        //     },
        //   ).toList(),
        //   products: (snap['products'] as List).map(
        //     (product) {
        //       return Product.fromSnapshot(product);
        //     },
        //   ).toList(),
        //   openingHours: (snap['openingHours'] as List).map(
        //     (openingHour) {
        //       return OpeningHours.fromSnapshot(openingHour);
        //     },
        //   ).toList(),
        //   address: Place.fromJson(snap['address']),
        );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      imageUrl,
    ];
  }
}
