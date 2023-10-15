import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String name;
  final String imageRes;
  final String description;
  final int price;
  final String category;

  Product(
      {this.id,
      required this.name,
      required this.imageRes,
      required this.description,
      required this.price,
      required this.category});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageRes': imageRes,
      'description': description,
      'price': price
    };
  }

  Product.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"],
        imageRes = doc.data()!["imageRes"],
        description = doc.data()!["description"],
        price = doc.data()!["price"],
        category = doc.data()!["category"];
}
