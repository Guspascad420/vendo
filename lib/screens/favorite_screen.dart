import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/database/database_service.dart';
import 'package:vendo/screens/cart/shopping_cart.dart';
import '../models/product.dart';
import '../models/users.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key, required this.favProducts, required this.removeFavProduct,
    required this.onAddToCart, required this.productsOnCart,
    required this.removeProductFromCart});

  final List<Product> favProducts;
  final List<Product> productsOnCart;
  final void Function(Product, int) removeProductFromCart;
  final void Function(Product) removeFavProduct;
  final void Function(Product, int) onAddToCart;

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  DatabaseService service = DatabaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  late Future<Users> futureUserData;
  late List<Product> _favProducts;

  Future<void> _showDialog(Product product) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Theme.of(context).colorScheme.background,
          actionsAlignment: MainAxisAlignment.spaceBetween,
          content: Text('Apakah kamu yakin ingin menghapus produk ini?',
              style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground)),
          actions: <Widget>[
            // const Color(0xFF314797)
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4)),
                child: Text('Tidak',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF314797)))
            ),
            ElevatedButton(
                onPressed: () {
                  widget.removeFavProduct(product);
                  setState(() {
                    _favProducts = _favProducts
                        .where((item) => item.id != product.id)
                        .toList();
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF314797),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4)),
                child: Text('Ya',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.background))
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _favProducts = widget.favProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)
          ),
          surfaceTintColor: Colors.white,
          title: Text('Favorit',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground)),
          centerTitle: true
      ),
      body: _favProducts.isEmpty ?
            emptyFavorite(context)
          : ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 10),
              itemCount: _favProducts.length,
              itemBuilder: (BuildContext context, int index) {
                return productOnFavorite(_favProducts[index], _showDialog);
          }),
      bottomNavigationBar: _favProducts.isEmpty ?
      const SizedBox() :
      GestureDetector(
          onTap: () {
            for (var product in _favProducts) {
              widget.onAddToCart(product, 1);
            }
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ShoppingCart(productsOnCart: widget.productsOnCart,
                        removeProductFromCart: widget.removeProductFromCart)));
          },
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              color: const Color(0xFF2A4399),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('Pesan sekarang',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 18, color: Colors.white)),
                const SizedBox(width: 10),
                const Icon(Icons.shopping_bag_outlined,
                    color: Colors.white, size: 30)
                ],
              )
          )
      )
    );
  }
}

Widget emptyFavorite(BuildContext context) {
  return Column(children: [
    SizedBox(height: MediaQuery.of(context).size.height * 0.18),
    Image.asset('images/sad.png'),
    const SizedBox(height: 20),
    Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Text('UUUPPPSSS!!!',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280))),
    ),
    Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Text('Kamu belum memiliki produk favorit',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280))),
    )
  ]);
}

Widget productOnFavorite(Product product, void Function(Product) onDeletePressed) {
  String dimension = product.category == "food" || product.category == "fashion"
      ? "gr" : "ml";
  return Container(
    height: 125,
    width: double.infinity,
    color: const Color(0xFFE9E9E9),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              height: 80,
              width: 80,
              margin: const EdgeInsets.only(left: 10),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: Image.network(
                'https://storage.googleapis.com/vendo/'
                    '${product.imageRes}',
                scale: 5,
              ),
            ),
            const SizedBox(width: 20),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Rp. ${product.price}",
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2A4399))),
                  Text(product.name,
                      style: GoogleFonts.inter(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  Text('${product.weight}$dimension',
                      style: GoogleFonts.inter(
                          fontSize: 15, color: const Color(0xFF868889)))
                ])
          ],
        ),
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: IconButton(onPressed: () { onDeletePressed(product); } ,
              icon: SvgPicture.asset('images/trash.svg'))
        )
      ],
    ),
  );
}
