import 'dart:convert';

import 'package:azblob/azblob.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vando/models/product.dart';
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

  Future<List<Product>> retrieveFourProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await db.collection("products").limit(4).get();
    return snapshot.docs
        .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Product>> retrieveAllProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await db.collection("products").get();
    return snapshot.docs
        .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
  
  Future<List<Product>> retrieveFoodProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await db.collection("products")
        .where("category", isEqualTo: "food").get();
    return snapshot.docs
        .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Product>> retrieveBeverageProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await db.collection("products")
        .where("category", isEqualTo: "beverage").get();
    return snapshot.docs
        .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Product>> retrieveFashionProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await db.collection("products")
        .where("category", isEqualTo: "fashion").get();
    return snapshot.docs
        .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}