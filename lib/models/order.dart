import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String? id;
  final String uniqueCode;
  final int price;
  final String status;
  final String userId;

  Order({this.id, required this.uniqueCode, required this.price,
    required this.status, required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'unique_code': uniqueCode,
      'price': price,
      'status': status,
      'user_id': userId
    };
  }

  Order.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
    : id = doc.id,
      uniqueCode = doc.data()!["unique_code"],
      price = doc.data()!["price"],
      status = doc.data()!["status"],
      userId = doc.data()!["user_id"];
}
