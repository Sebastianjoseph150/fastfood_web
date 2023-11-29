import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int index;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.index,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl, index];

  factory Category.fromSnapshot(Map<String, dynamic> snap) {
    return Category(
      id: snap['id'].toString(),
      name: snap['name'],
      description: snap['description'],
      imageUrl: snap['imageUrl'],
      index: snap['index'],
    );
  }

  static List<Category> categories = [
    Category(
      id: '1',
      name: 'main courses',
      description: 'This is a test description',
      imageUrl: 'images/burger1.jpg',
      index: 0,
    ),
    Category(
      id: '2',
      name: 'non-veg items',
      description: 'This is a test description',
      imageUrl: 'images/burger1.jpg',
      index: 1,
    ),
    Category(
      id: '3',
      name: 'bread items',
      description: 'This is a test description',
      imageUrl: 'images/burger1.jpg',
      index: 2,
    ),
    Category(
      id: '4',
      name: 'burger',
      description: 'This is a test description',
      imageUrl: 'images/burger1.jpg',
      index: 3,
    ),
    Category(
      id: '5',
      name: 'starters',
      description: 'This is a test description',
      imageUrl: 'images/burger1.jpg',
      index: 4,
    ),
    Category(
      id: '6',
      name: 'pizza',
      description: 'This is a test description',
      imageUrl: 'images/burger1.jpg',
      index: 4,
    ),
  ];
}
