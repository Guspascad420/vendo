import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:randomstring_dart/randomstring_dart.dart';
import 'package:vendo/models/order.dart';
import 'package:vendo/screens/payments/payment_completed.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../models/category.dart';
import '../../database/database_service.dart';
import '../../models/product.dart';

class EWalletPayment extends StatefulWidget {
  const EWalletPayment({super.key,
      required this.totalCost,
      required this.deeplinkRedirect,
      required this.transactionId,
      required this.productCategory,
      required this.productsOnCart});

  final int totalCost;
  final String deeplinkRedirect;
  final String transactionId;
  final Category productCategory;
  final List<Product> productsOnCart;

  @override
  State<EWalletPayment> createState() => _EWalletPaymentState();
}

class _EWalletPaymentState extends State<EWalletPayment> {
  late final WebViewController _controller;
  final rs = RandomString();
  DatabaseService service = DatabaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  String _uniqueCode = "";

  Future<void> _handleCompletedPayment(String id, List<Product> productsOnCart) async {
    for (var product in widget.productsOnCart) {
      service.removeProductFromCart(auth.currentUser!.uid, product,
          product.quantity!);
    }
    _createNewOrder();
  }

  void _createNewOrder() {
    setState(() {
      _uniqueCode = rs.getRandomString(lowersCount: 0, uppersCount: 3,
          specialsCount: 0).substring(0, 4);
    });
    String productCategory = widget.productCategory == Category.foodOrBeverage
        ? "F&B" : "Fashion";
    Order order = Order(uniqueCode: _uniqueCode,
        price: widget.totalCost, category: productCategory,
        status: "Sukses", userId: auth.currentUser!.uid);
    service.addOrder(order);
  }


  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            http.get(Uri.parse('https://midtrans-go-api--6h08mix.lemonpond-99927c12.'
                'southeastasia.azurecontainerapps.io/api/status/'
                    '${widget.transactionId}')).then((response) {
              if (response.statusCode == 200) {
                var data = jsonDecode(response.body) as Map<String, dynamic>;
                if (data["status"] == "settlement") {
                  _handleCompletedPayment(auth.currentUser!.uid, widget.productsOnCart)
                      .then((value) => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PaymentCompleted(
                          productCategory: widget.productCategory,
                          uniqueCode: _uniqueCode,
                        )
                      )
                    )
                  });
                }
              } else {
                throw Exception('Failed to post request');
              }
            });
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.deeplinkRedirect));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          surfaceTintColor: Colors.white,
          title: Text('Pembayaran E-Wallet',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground
              )),
          centerTitle: true
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
