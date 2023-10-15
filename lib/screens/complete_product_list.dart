import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vando/screens/main/home_screen.dart';
import 'package:vando/utils/static_grid.dart';
import '../models/database_service.dart';
import '../models/product.dart';

class CompleteProductList extends StatefulWidget {
  const CompleteProductList({super.key});

  @override
  State<CompleteProductList> createState() => _CompleteProductListState();
}

class _CompleteProductListState extends State<CompleteProductList> {
  DatabaseService service = DatabaseService();
  late Future<List<Product>> futureFoodList;
  late Future<List<Product>> futureBeverageList;
  late Future<List<Product>> futureFashionList;

  @override
  void initState() {
    super.initState();
    futureFoodList = service.retrieveFoodProducts();
    futureBeverageList = service.retrieveBeverageProducts();
    futureFashionList = service.retrieveFashionProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          leading: const Icon(Icons.arrow_back),
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFFE6E7E9)),
            margin: const EdgeInsets.symmetric(vertical: 30),
            padding: const EdgeInsets.symmetric(vertical: 5),
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
          ),
          actions: [
            Image.asset('images/shopping_cart.png', scale: 2),
            const SizedBox(width: 10)
          ],
        ),
        body: FutureBuilder(
          future: Future.wait([futureFoodList, futureBeverageList, futureFashionList]),
          builder: (context, AsyncSnapshot<List<List<Product>>> snapshot) {
            if(!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator()
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            var foodList = snapshot.data![0];
            var beverageList = snapshot.data![1];
            var fashionList = snapshot.data![2];
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  productCardHeader(context, 'Produk Makanan Kami!', () {}),
                  StaticGrid(
                      gap: 4,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: [
                        for (var i = 0; i < 4; i++)
                          productCard(context, foodList[i])
                      ]
                  ),
                  const SizedBox(height: 40),
                  productCardHeader(context, 'Produk Minuman Kami!', () {}),
                  StaticGrid(
                    gap: 4,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      for (var i = 0; i < 4; i++)
                        productCard(context, beverageList[i])
                    ]
                  ),
                  const SizedBox(height: 40),
                  productCardHeader(context, 'Produk Fashion Kami!', () {}),
                  StaticGrid(
                      gap: 4,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: [
                        for (var product in fashionList) productCard(context, product)
                      ]
                  )
                ],
              ),
            );
          },
        )
    );
  }
}
