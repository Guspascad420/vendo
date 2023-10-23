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
          ListTile(
            title: Text('QRIS',
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
              value: PaymentMethod.qris,
              groupValue: _method,
              onChanged: (PaymentMethod? value) {
                setState(() {
                  _method = value!;
                });
              },
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}