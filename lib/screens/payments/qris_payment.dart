import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/screens/payments/payment_completed.dart';
import 'package:vendo/utils/currency_format.dart';
import 'package:http/http.dart' as http;

import '../../models/category.dart';

class QrisPayment extends StatefulWidget {
  const QrisPayment({super.key, required this.totalCost,
    required this.qrisImageRes, required this.transactionId,
    required this.productCategory});

  final int totalCost;
  final String qrisImageRes;
  final String transactionId;
  final Category productCategory;

  @override
  State<QrisPayment> createState() => _QrisPaymentState();
}

class _QrisPaymentState extends State<QrisPayment> {

  Future<String> getStatus() async {
    final response = await http.get(Uri.parse('http://192.168.18.42:8080/api/status/'
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
        appBar: AppBar(
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
                        ))
                  ],
                );
              } else {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => PaymentCompleted(
                              productCategory: widget.productCategory
                          )
                      )
                  );
                });
              }
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}',
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