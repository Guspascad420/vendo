import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String name;
  final String imageRes;
  final String? description;
  final int price;
  final String? category;
  final int? quantity;

  Product({this.id,
      required this.name,
      required this.imageRes,
      this.description = "",
      required this.price,
      this.category = "",
      this.quantity = 0});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image_res': imageRes,
      'description': description,
      'price': price,
      'category': category
    };
  }

  Map<String, dynamic> toFavMap() {
    return {'id': id, 'name': name, 'price': price, 'image_res': imageRes};
  }

  Map<String, dynamic> toCartMap(int quantity) {
    return {'id': id, 'name': name, 'price': price, 'quantity': quantity, 'image_res': imageRes};
  }
  
  factory Product.toProductOnCart(Map<String, dynamic> productMap) {
    return Product(id: productMap['id'], name: productMap['name'], imageRes: productMap['image_res'],
        price: productMap['price'], quantity: productMap["quantity"]);
  }

  factory Product.toFavProduct(Map<String, dynamic> productMap) {
    return Product(id: productMap['id'], name: productMap['name'], imageRes: productMap['image_res'],
        price: productMap['price']);
  }



  Product.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"],
        imageRes = doc.data()!["image_res"],
        description = doc.data()?["description"],
        price = doc.data()!["price"],
        category = doc.data()?["category"],
        quantity = doc.data()?["quantity"];
}
