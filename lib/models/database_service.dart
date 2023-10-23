import 'dart:convert';

import 'package:azblob/azblob.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendo/models/product.dart';
import 'package:vendo/models/review.dart';
import 'package:vendo/models/users.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future fetchImage(AzureStorage storage) async {
    final Xml2Json xml2Json = Xml2Json();
    var streamedResponse = await storage.listBlobsRaw('/democontainer/images/');
    var response = await http.Response.fromStream(streamedResponse);
    xml2Json.parse(response.body);
    var jsonString = xml2Json.toParker();
    var data = jsonDecode(jsonString);
    return data;
  }

  createNewUser(Users user) async {
    await db.collection("users").doc(user.email).set(user.toMap());
  }

  addProductToCart(String email, Product product, int quantity) async {
    await db.collection("users").doc(email).update({
      'products_on_cart': FieldValue.arrayUnion([product.toCartMap(quantity)])
    });
  }
  
  addUserReview(Review review) async {
    await db.collection("reviews").add(review.toMap());
  }

  Future<List<Review>> retrieveDummyReviews() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await db.collection("reviews").get();
    return snapshot.docs
        .map((docSnapshot) => Review.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  removeProductFromCart(String email, Product product, int quantity) async {
    await db.collection("users").doc(email).update({
      'products_on_cart': FieldValue.arrayRemove([product.toCartMap(quantity)])
    });
  }

  addProductToFavorite(String email, Product product) async {
    await db.collection("users").doc(email).update({
      'fav_products': FieldValue.arrayUnion([product.toFavMap()])
    });
  }

  removeProductFromFavorite(String email, Product product) async {
    await db.collection("users").doc(email).update({
      'fav_products': FieldValue.arrayRemove([product.toFavMap()])
    });
  }

  Future<Users> retrieveUserData(String email) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await db.collection("users").doc(email).get();
    return Users.fromDocumentSnapshot(snapshot);
  }

  Future<List<Product>> retrieveFourProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection("products").limit(4).get();
    return snapshot.docs
        .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Product>> retrieveAllProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection("products").get();
    return snapshot.docs
        .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Product>> retrieveFoodProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection("products")
        .where("category", isEqualTo: "food")
        .get();
    return snapshot.docs
        .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Product>> retrieveBeverageProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection("products")
        .where("category", isEqualTo: "beverage")
        .get();
    return snapshot.docs
        .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Product>> retrieveFashionProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection("products")
        .where("category", isEqualTo: "fashion")
        .get();
    return snapshot.docs
        .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
