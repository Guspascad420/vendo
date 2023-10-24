import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String fullName;
  final String email;
  final String phoneNumber;
  List<Map<String, dynamic>> productsOnCart;
  List<Map<String, dynamic>> favProducts;

  Users({required this.fullName,
      required this.email,
      required this.productsOnCart,
      required this.favProducts, required this.phoneNumber});

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'products_on_cart': productsOnCart,
      'fav_products': favProducts
    };
  }

  Users.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : fullName = doc.data()!["full_name"],
        email = doc.data()!["email"],
        phoneNumber =  doc.data()!["phone_number"],
        productsOnCart = doc.data()?["products_on_cart"].cast<Map<String, dynamic>>(),
        favProducts = doc.data()?["fav_products"].cast<Map<String, dynamic>>();
}
