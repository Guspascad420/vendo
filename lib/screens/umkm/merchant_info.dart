import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timelines/timelines.dart';
import 'package:vendo/screens/umkm/product_regist_category.dart';

import '../../utils/reusable_widgets.dart';

class MerchantInfo extends StatelessWidget {
  const MerchantInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameTextController = TextEditingController();
    final TextEditingController _emailTextController = TextEditingController();
    final TextEditingController _phoneTextController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          surfaceTintColor: Colors.white,
          title: Text('Atur Informasi Toko',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground)),
          centerTitle: true
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            timelineView(0),
            const SizedBox(height: 45),
            Text("Nama Toko",
                style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            reusableTextField("", false, _nameTextController),
            const SizedBox(height: 30),
            Text("Email",
                style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            reusableTextField("", false, _emailTextController),
            const SizedBox(height: 30),
            Text("Nomor Telepon",
                style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            reusableTextField("", false, _nameTextController),
            Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 50),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ProductRegistCategory()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A4399),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 85, vertical: 12)),
                      child: Text('Submit',
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
      ),
    );
  }
}
