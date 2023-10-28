import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String? id;
  final String uniqueCode;
  final int price;
  final String status;
  final String category;
  final String userId;

  Order({this.id, required this.uniqueCode, required this.category, required this.price,
    required this.status, required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'unique_code': uniqueCode,
      'price': price,
      'category': category,
      'status': status,
      'user_id': userId
    };
  }

  Order.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
    : id = doc.id,
      uniqueCode = doc.data()!["unique_code"],
      price = doc.data()!["price"],
      category = doc.data()!["category"],
      status = doc.data()!["status"],
      userId = doc.data()!["user_id"];
}
