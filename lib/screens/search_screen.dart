import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: const Icon(Icons.arrow_back),
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFE6E7E9)),
          margin: const EdgeInsets.symmetric(vertical: 30),
          padding: const EdgeInsets.symmetric(vertical: 14),
          width: 310,
          child: Row(
            children: [
              const SizedBox(width: 25),
              const Icon(Icons.search,
                  color: Color(0xFF9CA3AF), size: 30),
              const SizedBox(width: 5),
              Text('Search',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: const Color(0xFF9CA3AF)))
            ],
          ),
        )
      ),
      body: Container(
        color: const Color(0xFFF4F5F9),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Search History',
                    style: GoogleFonts.inter(
                        fontSize: 21, color: Theme.of(context).colorScheme.onBackground)),
                Text('Clear',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500,
                        color: const Color(0xFF407EC7)))
              ],
            )
          ],
        ),
      ),
    );
  }

}