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

  createNewUser(Users user, String uid) async {
    await db.collection("users").doc(uid).set(user.toMap());
  }

  addProductToCart(String id, Product product, int quantity) async {
    await db.collection("users").doc(id).update({
      'products_on_cart': FieldValue.arrayUnion([product.toCartMap(quantity)])
    });
  }

  updateUserBio(String id, String newFullName,
      String newEmail, String newPhoneNumber) async {
    await db.collection("users").doc(id).update({"fullName" : newFullName});
    await db.collection("users").doc(id).update({"email" : newEmail});
    await db.collection("users").doc(id).update({"phone_number" : newPhoneNumber});
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

  removeProductFromCart(String id, Product product, int quantity) async {
    await db.collection("users").doc(id).update({
      'products_on_cart': FieldValue.arrayRemove([product.toCartMap(quantity)])
    });
  }

  addProductToFavorite(String id, Product product) async {
    await db.collection("users").doc(id).update({
      'fav_products': FieldValue.arrayUnion([product.toFavMap()])
    });
  }

  removeProductFromFavorite(String id, Product product) async {
    await db.collection("users").doc(id).update({
      'fav_products': FieldValue.arrayRemove([product.toFavMap()])
    });
  }

  Future<Users> retrieveUserData(String id) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await db.collection("users").doc(id).get();
    return Users.fromDocumentSnapshot(snapshot);
  }

  Future<List<Product>> retrieveFourProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection("products").limit(4).get();
    return snapshot.docs
        .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Product>> retrievePromotionalProducts() async {
    List<Product> promotionalProducts = [];
    DocumentSnapshot<Map<String, dynamic>> firstProductsnapshot =
    await db.collection("products").doc("rsN23lK448sPO43Qc0PW").get();
    DocumentSnapshot<Map<String, dynamic>> secondProductSnapshot =
    await db.collection("products").doc("0gt28KKSRbVXEo0dhhIT").get();

    promotionalProducts.add(Product.fromDocumentSnapshot(firstProductsnapshot));
    promotionalProducts.add(Product.fromDocumentSnapshot(secondProductSnapshot));
    return promotionalProducts;
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
