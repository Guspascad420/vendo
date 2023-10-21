import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/utils/currency_format.dart';

class MerchantDashboard extends StatelessWidget {
  const MerchantDashboard({super.key});

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
          title: Text('Toko Saya',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground)),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {}, 
                icon: const Icon(Icons.notifications)
            )
          ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Divider(),
          merchantBiodata(),
          const Divider(),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Text(
                'Performa Penjualan',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                )
            )
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              sellingPerformanceTopic('Total penjualan', 1298),
              const SizedBox(width: 10),
              // sellingPerformanceTopic('Rata-rata penjualan/bulan', 254),
              const SizedBox(width: 10),
              sellingPerformanceTopic('Total pemasukan',  6490000),
            ],
          )
        ],
      ),
    );
  }
}

Widget sellingPerformanceTopic(String title, int number) {
  return Container(
    padding: const EdgeInsets.all(20),
    color: Colors.grey[300],
    child: Column(
      children: [
        Text(
            CurrencyFormat.basicConversion(number),
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            )
        ),
        Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            )
        )
      ],
    ),
  );
}

Widget merchantBiodata() {
  return Row(
    children: [
      Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'D\'Sruput Store',
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
              )
          ),
          Text(
              'kylianmbappe@gmail.com',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: Colors.grey
              )
          )
        ],
      )
    ],
  );
}