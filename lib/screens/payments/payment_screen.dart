import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/models/payment_method.dart';
import 'package:vendo/screens/payments/ewallet_payment.dart';
import 'package:vendo/screens/payments/qris_payment.dart';
import 'package:vendo/utils/reusable_widgets.dart';
import 'package:http/http.dart' as http;

import '../../models/category.dart';
import '../../models/product.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.subtotal,
    required this.valueAddedTax, required this.totalCost,
    required this.isVoucherEnabled, required this.discountPrice,
    required this.productCategory, required this.productsOnCart});

  final int subtotal;
  final double valueAddedTax;
  final int totalCost;
  final bool isVoucherEnabled;
  final int discountPrice;
  final Category productCategory;
  final List<Product> productsOnCart;

  @override
  State<PaymentScreen> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentScreen> {
  PaymentMethod _method = PaymentMethod.qris;
  bool _isLoading = false;

  void setPaymentMethod(PaymentMethod method) {
    setState(() {
      _method = method;
    });
  }

  Future<void> _makePayment() async {
    setState(() {
      _isLoading = true;
    });
    http.post(
      Uri.parse('https://midtrans-go-api.lemonpond-99927c12.southeastasia.azure'
          'containerapps.io/api/charge'),
      body: jsonEncode(<String, dynamic> {
        'payment_type': _method.name,
        'gross_amount': 30000
      })
    ).then((response){
      if (response.statusCode == 201) {
        var data = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _isLoading = false;
        });
        if (_method == PaymentMethod.qris) {
          debugPrint(data["qr_code_url"]);
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => QrisPayment(totalCost: widget.totalCost,
                      qrisImageRes: data["qr_code_url"],
                      transactionId: data["transaction_id"],
                      productCategory: widget.productCategory,
                      productsOnCart: widget.productsOnCart)
              )
          );
        } else {
          debugPrint(data["deeplink_redirect"]);
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => EWalletPayment(totalCost: widget.totalCost,
                      deeplinkRedirect: data["deeplink_redirect"],
                      transactionId: data["transaction_id"],
                      productCategory: widget.productCategory,
                      productsOnCart: widget.productsOnCart)
              )
          );
        }
      } else  {
        throw Exception('Failed to post request');
      }
    });

  }

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
          title: Text('Metode Pembayaran',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground)),
          centerTitle: true
      ),
      bottomNavigationBar: shoppingBottomNavBar(context, widget.subtotal,
          widget.valueAddedTax, widget.totalCost, false, widget.isVoucherEnabled,
          _makePayment, null, widget.discountPrice, _isLoading),
      body: Column(
        children: [
          const Divider(),
          paymentMethod("QRIS", PaymentMethod.qris, _method, 'images/qris.png', setPaymentMethod),
          paymentMethod("Shopeepay", PaymentMethod.shopeepay, _method,
              'images/shopee_pay.png', setPaymentMethod),
          paymentMethod("Gopay", PaymentMethod.gopay,
              _method, 'images/gopay.png', setPaymentMethod),
          ListTile(
            title: Text('Metamask',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
            subtitle: Text('Coming soon',
                style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.grey
                )),
            leading: Image.asset('images/metamask_fox.png', scale: 2.5,),
          ),
          const Divider()
        ],
      ),
    );
  }
}

Widget paymentMethod(String title, PaymentMethod value, PaymentMethod methodGroup,
    String imageRes,
    void Function(PaymentMethod) setPaymentMethod,
    ) {
  return GestureDetector(
    onTap: () {
      setPaymentMethod(value);
    },
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            title: Text(title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
            subtitle: Text('Biaya Penanganan 0%',
                style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.grey
                )),
            leading: Image.asset(imageRes, scale: 2.5,),
            trailing: Radio<PaymentMethod>(
              value: value,
              groupValue: methodGroup,
              onChanged: (PaymentMethod? value) {
                setPaymentMethod(value!);
              },
            ),
          )
        ),
        const Divider()
      ],
    ),
  );
}