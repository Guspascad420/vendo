import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const Icon(Icons.arrow_back),
          surfaceTintColor: Colors.white,
          title: Text('Favorit',
              style: GoogleFonts.inter(
                  fontSize: 20, fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground)),
          centerTitle: true
      ),
      body: Column(
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
              child: Text('Kamu belum memiliki produk favorit',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280))),
            )
          ]
      ),
      bottomNavigationBar: const SizedBox(),
    );
  }
}