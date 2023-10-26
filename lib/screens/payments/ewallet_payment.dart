import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/screens/payments/payment_completed.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../models/category.dart';

class EWalletPayment extends StatefulWidget {
  const EWalletPayment({super.key,
      required this.totalCost,
      required this.deeplinkRedirect,
      required this.transactionId,
      required this.productCategory});

  final int totalCost;
  final String deeplinkRedirect;
  final String transactionId;
  final Category productCategory;

  @override
  State<StatefulWidget> createState() => _EWalletPaymentState();
}

class _EWalletPaymentState extends State<EWalletPayment> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            http.get(Uri.parse('http://192.168.18.42:8080/api/status/'
                    '${widget.transactionId}')).then((response) {
              if (response.statusCode == 200) {
                var data = jsonDecode(response.body) as Map<String, dynamic>;
                if (data["status"] == "settlement") {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => PaymentCompleted(
                              productCategory: widget.productCategory
                          )
                      )
                  );
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
