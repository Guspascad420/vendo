import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<StatefulWidget> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const Icon(Icons.arrow_back),
          surfaceTintColor: Colors.white,
          title: Text('Shopping Cart',
              style: GoogleFonts.inter(
                  fontSize: 20, fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground)),
          centerTitle: true
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.18),
          Center(
            child: Image.asset('images/empty_cart.png', scale: 3),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Text('Wah, keranjang belanjamu kosong Yuk, telusuri produk UMKM pilihan kami!',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280)))
          )
        ]
      ),
      bottomNavigationBar: const SizedBox(),
    );
  }

}