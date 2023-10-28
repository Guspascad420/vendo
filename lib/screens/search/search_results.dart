import 'package:flutter/material.dart';
import 'package:vendo/database/database_service.dart';
import 'package:vendo/utils/reusable_widgets.dart';

import '../../models/product.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({super.key, required this.searchQuery,
    required this.isFavorite, required this.setFavProduct,
    required this.addProductToCart});

  final String searchQuery;
  final bool Function(Product) isFavorite;
  final void Function(Product) setFavProduct;
  final void Function(Product, int) addProductToCart;

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late Future<List<Product>> futureProductList;
  DatabaseService service = DatabaseService();

  @override
  void initState() {
    super.initState();
    futureProductList = service.retrieveSearchResults(widget.searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureProductList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              crossAxisCount: 2,
              children: List.generate(snapshot.data!.length, (index) {
                return productCard(context, snapshot.data![index],
                    widget.isFavorite(snapshot.data![index]),
                    widget.setFavProduct,
                    widget.addProductToCart
                );
              }),
          );
        }
    );
  }
}