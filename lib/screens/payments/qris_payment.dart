import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:randomstring_dart/randomstring_dart.dart';
import 'package:vendo/database/database_service.dart';
import 'package:vendo/screens/payments/payment_completed.dart';
import 'package:vendo/utils/currency_format.dart';
import 'package:http/http.dart' as http;

import '../../models/category.dart';
import '../../models/order.dart';
import '../../models/product.dart';

class QrisPayment extends StatefulWidget {
  const QrisPayment({super.key, required this.totalCost,
    required this.qrisImageRes, required this.transactionId,
    required this.productCategory, required this.productsOnCart});

  final int totalCost;
  final String qrisImageRes;
  final String transactionId;
  final Category productCategory;
  final List<Product> productsOnCart;

  @override
  State<QrisPayment> createState() => _QrisPaymentState();
}

class _QrisPaymentState extends State<QrisPayment> {

  DatabaseService service = DatabaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  final rs = RandomString();

  Future<void> _handleCompletedPayment(String id, List<Product> productsOnCart) async {
    for (var product in widget.productsOnCart) {
      service.removeProductFromCart(auth.currentUser!.uid, product,
          product.quantity!);
    }
    _createNewOrder();
  }

  void _createNewOrder() {
    var uniqueCode = rs.getRandomString(lowersCount: 0, uppersCount: 3,
          specialsCount: 0).substring(0, 4);
    String productCategory = widget.productCategory == Category.foodOrBeverage
        ? "F&B" : "Fashion";
    Order order = Order(uniqueCode: uniqueCode,
        price: widget.totalCost, category: productCategory,
        status: "Sukses", userId: auth.currentUser!.uid);
    service.addOrder(order);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => PaymentCompleted(
                productCategory: widget.productCategory,
                uniqueCode: uniqueCode
            )
        )
    );
  }

  Future<String> getStatus() async {
    final response = await http.get(Uri.parse('https://midtrans-go-api-3oobx6gbjq-as.a.run.app/api/status/'
        '${widget.transactionId}'));
    String status;
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint(data["status"]);
      status = data["status"]! as String;
    } else {
      throw Exception('Failed to post request');
    }
    return status;
  }

  late Stream<String> stream = Stream.periodic(const Duration(seconds: 5))
      .asyncMap((event) async => await getStatus());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            toolbarHeight: 80,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)
            ),
            surfaceTintColor: Colors.white,
            title: Text('Pembayaran QRIS',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onBackground)),
            centerTitle: true
        ),
        body: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String status = snapshot.data!;
              if (status == "pending") {
                return Column(
                  children: [
                    const SizedBox(height: 50),
                    Image.asset('images/qris.png', scale: 2.5),
                    Image.network(widget.qrisImageRes),
                    Text(CurrencyFormat.convertToIdr(widget.totalCost),
                        style: GoogleFonts.inter(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        )),
                    Container(
                      width: MediaQuery.of(context).size.height * 0.3,
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Text('Salin link dibawah untuk mensimulasikan pembayaran '
                          'pada QRIS Simulator',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                          ))
                    ),
                    SelectableText(widget.qrisImageRes,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                        ))
                  ],
                );
              } else {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  _handleCompletedPayment(auth.currentUser!.uid, widget.productsOnCart);
                });
              }
            } else if (snapshot.hasError) {
              return Text('Mohon cek koneksi internet kamu',
                  style: GoogleFonts.inter(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ));
            }
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2A4399)),
            );
          }
        )
      ,
    );
  }

}