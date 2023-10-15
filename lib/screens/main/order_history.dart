import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
        Image.asset('images/sad.png'),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Text('UUUPPPSSS!!!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280))),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Text('Kamu belum memesan apa-apa Silahkan lakukan pemesanan dan pembayaran',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280))),
        )
      ],
    );
  }
}
