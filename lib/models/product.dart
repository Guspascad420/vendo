import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String name;
  final String imageRes;
  final String? description;
  final int price;
  final String? category;
  final int? quantity;
  final int weight;

  Product({this.id,
      required this.name,
      required this.imageRes,
      this.description = "",
      required this.price,
      this.category = "",
      this.quantity = 0,
      required this.weight});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_res': imageRes,
      'description': description,
      'price': price,
      'category': category,
      'weight': weight
    };
  }

  Map<String, dynamic> toFavMap() {
    return {'id': id, 'name': name, 'price': price, 'image_res': imageRes, 'weight': weight};
  }

  Map<String, dynamic> toCartMap(int quantity) {
    return {'id': id, 'name': name, 'price': price, 'quantity': quantity,
      'image_res': imageRes, 'category': category, 'weight': weight};
  }
  
  factory Product.toProductOnCart(Map<String, dynamic> productMap) {
    return Product(id: productMap['id'], name: productMap['name'], imageRes: productMap['image_res'],
        price: productMap['price'], quantity: productMap["quantity"], category: productMap["category"],
        weight: productMap['weight']);
  }

  factory Product.toFavProduct(Map<String, dynamic> productMap) {
    return Product(id: productMap['id'], name: productMap['name'], imageRes: productMap['image_res'],
        price: productMap['price'], weight: productMap['weight']);
  }


  Product.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"],
        imageRes = doc.data()!["image_res"],
        description = doc.data()?["description"],
        price = doc.data()!["price"],
        category = doc.data()?["category"],
        weight = doc.data()!["weight"],
        quantity = doc.data()?["quantity"];
}
