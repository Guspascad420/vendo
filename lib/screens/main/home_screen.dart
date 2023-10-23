import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vendo/models/product.dart';
import 'package:vendo/screens/complete_product_list.dart';
import 'package:vendo/screens/product_details/product_details.dart';
import 'package:vendo/screens/search_screen.dart';
import 'package:vendo/screens/vendo_map.dart';

import '../../models/database_service.dart';
import '../../models/users.dart';
import '../../utils/reusable_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.favProducts,
    required this.productsOnCart, required this.setFavProduct,
    required this.isFavorite, required this.addProductToCart,
    required this.removeProductFromCart});

  final List<Product> favProducts;
  final List<Product> productsOnCart;
  final void Function(Product, int) addProductToCart;
  final void Function(Product, int) removeProductFromCart;
  final void Function(Product) setFavProduct;
  final bool Function(Product) isFavorite;

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> futureProductList;
  DatabaseService service = DatabaseService();
  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    futureProductList = service.retrieveFourProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchScreen()));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: const Color(0xFFE6E7E9)),
              margin: const EdgeInsets.symmetric(vertical: 30),
              padding: const EdgeInsets.symmetric(vertical: 10),
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
            )),
        const SizedBox(height: 10),
        SizedBox(
          height: 242,
          child: PageView(
            controller: controller,
            children: [promotionalCardContent(), promotionalCardContent()],
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
            controller: controller, count: 2, effect: const SlideEffect()),
        const SizedBox(height: 30),
        Center(
            child: Text('Category',
                style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onBackground))),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            categoryItem(
                'images/food_order.png',
                'Food & Beverages Vending Machine',
                const Color(0xFFE6F2EA),
                150,
                0),
            categoryItem('images/beauty_products.png',
                'Fashion Vending Machine', const Color(0xFFFFE9E5), 120, 7)
          ],
        ),
        const SizedBox(height: 40),
        productCardHeader(context, 'Lihat Produk Kami', () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CompleteProductList(
                    favProducts: widget.favProducts,
                    isProductsOnCart: widget.productsOnCart.isNotEmpty,
                    productsOnCartCount: widget.productsOnCart.length,
                    productsOnCart: widget.productsOnCart,
                    addProductToCart: widget.addProductToCart,
                    onIconTapped: widget.setFavProduct,
                    isFavorite: widget.isFavorite,
                    removeProductFromCart: widget.removeProductFromCart
                  )));
        }),
        FutureBuilder(
            future: futureProductList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var productList = snapshot.data!;
                return SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10,
                    ),
                    itemBuilder: (context, index) {
                      return productCard(
                          context, productList[index], widget.productsOnCart,
                          widget.isFavorite(productList[index]),
                          widget.setFavProduct, widget.addProductToCart
                      );
                    },
                    itemCount: productList.length,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text('Lokasi Vending Machine',
                        style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),
                  SizedBox(
                    width: 200,
                    child: Text('Temukan Vending Machine di sekitar anda',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B7280))),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const VendoMap()));
                      },
                      child: Text('See all',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6B7280)))),
                  const Icon(Icons.arrow_forward_ios_sharp,
                      color: Color(0xFF6B7280))
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        locationCard(
            context,
            'UB Library',
            'Jl. Veteran, Ketawanggede, Kec. Lowokwaru',
            'images/rectangle_387.png'),
        const SizedBox(height: 40)
      ]),
    );
  }
}

Widget locationCard(
    BuildContext context, String name, String address, String imageRes) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    child: Card(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        //set border radius more than 50% of height and width to make circle
      ),
      child: ListTile(
        leading: Image.asset(imageRes),
        title: Text(name,
            style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground)),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Color(0xFF2A4399)),
            SizedBox(
                width: 120,
                child: Text(address,
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onBackground)))
          ],
        ),
        trailing: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                backgroundColor: const Color(0xFF314797),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))),
            child: Text('Lihat',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ))),
      ),
    ),
  );
}

Widget categoryItem(String imageRes, String title, Color containerColor,
    double textWidth, double containerPadding) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: containerPadding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: containerColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 5), // changes position of shadow
              )
            ]),
        child: Image.asset(imageRes, scale: 2),
      ),
      const SizedBox(height: 20),
      SizedBox(
          width: textWidth,
          child: Text(title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF868889))))
    ],
  );
}

Widget promotionalCardContent() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 25),
    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      // Box decoration takes a gradient
      gradient: const LinearGradient(
        // Where the linear gradient begins and ends
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        // Add one stop for each color. Stops should increase from 0 to 1
        colors: [
          // Colors are easy thanks to Flutter's Colors class.
          Color(0xFFFFE1B4),
          Color(0xFFFF9F06)
        ],
      ),
    ),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('D\'Sruput',
                style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 50),
            Text('Flash Offer',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 10),
            SizedBox(
              width: 150,
              child: Text(
                  'We are here with the best '
                  'soy milk in indonesia',
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('Order',
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const Icon(Icons.arrow_forward_ios_sharp, color: Colors.white)
              ],
            )
          ],
        ),
        Expanded(
            child: Container(
                alignment: AlignmentDirectional.centerEnd,
                margin: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  'images/d_sruput.png',
                  scale: 2.4,
                )))
      ],
    ),
  );
}
