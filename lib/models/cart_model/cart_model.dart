class CartItem {
  final String itemId;
  final String name;
  final String description;
  final double price;
  int quantity;
  final String imagepath;
  final String restaurant;

  CartItem({
    required this.itemId,
    required this.imagepath,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.restaurant,
  });

  CartItem copyWith({int? quantity, String? restaurant}) {
    return CartItem(
      itemId: itemId,
      name: name,
      description: description,
      price: price,
      quantity: quantity ?? this.quantity,
      imagepath: imagepath,
      restaurant: restaurant ?? this.restaurant,
    );
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      itemId: map['itemId'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      imagepath: map['imagepath'] as String,
      restaurant: map['restaurant'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'imagepath': imagepath,
      'restaurant': restaurant,
    };
  }
}
