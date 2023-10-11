import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vando/screens/main/main_screen.dart';

class ProductRecommendations extends StatelessWidget {
  const ProductRecommendations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(context),

    )
      SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFE6E7E9)),
            margin: const EdgeInsets.symmetric(vertical: 30),
            padding: const EdgeInsets.symmetric(vertical: 14),
            width: 310,
            child: Row(
              children: [
                const SizedBox(width: 25),
                const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 30),
                const SizedBox(width: 5),
                Text('Search',
                    style: GoogleFonts.inter(
                        fontSize: 14, color: const Color(0xFF9CA3AF)))
              ],
            ),
          )
        ],
      ),
    );
  }
}
