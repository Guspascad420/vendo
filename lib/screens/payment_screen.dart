import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/models/payment_method.dart';
import 'package:vendo/utils/reusable_widgets.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.subtotal,
    required this.valueAddedTax, required this.totalCost});

  final int subtotal;
  final double valueAddedTax;
  final int totalCost;

  @override
  State<StatefulWidget> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentScreen> {
  PaymentMethod _method = PaymentMethod.qris;

  void setPaymentMethod(PaymentMethod method) {
    setState(() {
      _method = method;
    });
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
          widget.valueAddedTax, widget.totalCost, false, () { }),
      body: Column(
        children: [
          const Divider(),
          paymentMethod("QRIS", PaymentMethod.qris, _method, setPaymentMethod),
          paymentMethod("Shopeepay", PaymentMethod.shopeePay, _method, setPaymentMethod),
          paymentMethod("Gopay", PaymentMethod.gopay, _method, setPaymentMethod),
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
            leading: Image.asset('images/qris.png', scale: 2.5,),
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