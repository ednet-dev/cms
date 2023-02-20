class Address {
  String street;
  String city;
  String country;

  Address({
    required this.street,
    required this.city,
    required this.country,
  });

  Address.fromMap(Map<String, dynamic> data)
      : street = data['street'],
        city = data['city'],
        country = data['country'];
}
