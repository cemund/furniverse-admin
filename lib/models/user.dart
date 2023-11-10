class UserModel {
  final String name;
  final String email;
  final dynamic shippingAddress;
  final dynamic token;
  final String contactNumber;

  UserModel(
      {required this.name,
      required this.email,
      required this.shippingAddress,
      required this.token,
      required this.contactNumber});

  factory UserModel.fromMap(Map data) {
    return UserModel(
      name: data['name'] ?? "",
      email: data['email'] ?? "",
      shippingAddress: data['shippingAddress'] ?? {},
      contactNumber: data['contactNumber'] ?? "",
      token: data['token'] ?? "",
    );
  }

  String getStringAddress() {
    List<String> components = [];

    components.add(shippingAddress['street'] ?? '');
    components.add(shippingAddress['baranggay'] ?? '');
    components.add(shippingAddress['city'] ?? '');
    components.add(shippingAddress['province'] ?? '');
    components.add(shippingAddress['zipCode'] ?? '');

    return components.join(', ');
  }
}
