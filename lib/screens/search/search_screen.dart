import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/screens/search/search_results.dart';

import '../../models/product.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.isFavorite,
    required this.setFavProduct, required this.addProductToCart});

  final bool Function(Product) isFavorite;
  final void Function(Product) setFavProduct;
  final void Function(Product, int) addProductToCart;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: TextField(
              autofocus: true,
              onSubmitted: (_) {
                setState(() {
                  _isSearching = true;
                });
              },
              controller: _searchTextController,
              cursorColor: Colors.black,
              style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.all(2),
                labelText: "Search keywords..",
                prefixIcon: const Icon(Icons.search, size: 30,),
                labelStyle: const TextStyle(color: Color(0xFF868889)),
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                fillColor: const Color(0xFFE6E7E9),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17.0),
                  borderSide: const BorderSide(width: 1, color: Color(0xFFE6E7E9))
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17.0),
                    borderSide: const BorderSide(width: 1, color: Color(0xFFE6E7E9))
                ),
              ),
          )
        )
      ),
      body: !_isSearching ? Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Riwayat Pencarian',
                    style: GoogleFonts.inter(
                        fontSize: 21, fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onBackground)),
                Text('Bersihkan',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500,
                        color: const Color(0xFF407EC7))),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ) : SearchResults(searchQuery: _searchTextController.text,
          isFavorite: widget.isFavorite, setFavProduct: widget.setFavProduct,
          addProductToCart: widget.addProductToCart),
    );
  }
}