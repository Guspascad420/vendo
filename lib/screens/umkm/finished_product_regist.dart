import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vando/screens/umkm/merchant_dashboard.dart';

import '../../utils/reusable_widgets.dart';

class FinishedProductRegist extends StatelessWidget {
  const FinishedProductRegist({super.key});

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
            title: Text('Daftarkan Produk',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onBackground)),
            centerTitle: true
        ),
      body: Column(
        children: [
          timelineView(1),
          const SizedBox(height: 100),
          Image.asset('images/success_icon.png', scale: 2,),
          const SizedBox(height: 20),
          Text('Selamat!',
              style: GoogleFonts.inter(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground)),
          Container(
           margin: const EdgeInsets.symmetric(horizontal: 33, vertical: 10),
           child: Text("Produk kamu sudah didaftarkan "
               "Tunggu selama 3x24jam kerja, kami akan mengirimkan email untuk "
               "proses validasi. ",
               textAlign: TextAlign.center,
               style: GoogleFonts.inter(
                   fontSize: 17,
                   color: Colors.grey)),
          ),
          Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MerchantDashboard()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A4399),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 12)),
                    child: Text('Dashboard Penjual',
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.background
                        ))
                ),
              )
          )
        ],
      ),
    );
  }

}