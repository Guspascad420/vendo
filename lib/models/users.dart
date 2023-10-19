import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String fullName;
  final String email;
  List<Map<String, dynamic>> productsOnCart;
  List<Map<String, dynamic>> favProducts;

  Users(
      {required this.fullName,
      required this.email,
      required this.productsOnCart,
      required this.favProducts});

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'email': email,
      'products_on_cart': productsOnCart,
      'fav_products': favProducts
    };
  }

  Users.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : fullName = doc.data()!["full_name"],
        email = doc.id,
        productsOnCart = doc.data()?["products_on_cart"].cast<Map<String, dynamic>>(),
        favProducts = doc.data()?["fav_products"].cast<Map<String, dynamic>>();
}
