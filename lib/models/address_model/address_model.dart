class Address {
  String name;
  String street;
  String city;
  String postalCode;

  Address({
    required this.name,
    required this.street,
    required this.city,
    required this.postalCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'street': street,
      'city': city,
      'postalCode': postalCode,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      name: map['name'],
      street: map['street'],
      city: map['city'],
      postalCode: map['postalCode'],
    );
  }
}
