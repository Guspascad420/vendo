import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/models/voucher.dart';
import 'package:vendo/screens/main/home_screen.dart';
import 'package:vendo/screens/cart/shopping_cart.dart';
import 'package:vendo/screens/search/search_screen.dart';
import 'package:vendo/utils/scroll_to_hide_widget.dart';
import 'package:vendo/utils/static_grid.dart';
import '../../database/database_service.dart';
import '../../models/product.dart';
import '../../models/users.dart';
import '../../utils/reusable_widgets.dart';

class CompleteProductList extends StatefulWidget {
  const CompleteProductList(
      {super.key,
      required this.favProducts,
      required this.isProductsOnCart,
      required this.productsOnCartCount,
      required this.productsOnCart,
      required this.onIconTapped,
      required this.isFavorite,
      required this.addProductToCart,
      required this.removeProductFromCart
     });

  final List<Product> favProducts;
  final List<Product> productsOnCart;
  final bool isProductsOnCart;
  final int productsOnCartCount;
  final void Function(Product) onIconTapped;
  final bool Function(Product) isFavorite;
  final void Function(Product, int) addProductToCart;
  final void Function(Product, int) removeProductFromCart;

  @override
  State<CompleteProductList> createState() => _CompleteProductListState();
}

class _CompleteProductListState extends State<CompleteProductList> {
  DatabaseService service = DatabaseService();
  late Future<List<Product>> futureFoodList;
  late Future<List<Product>> futureBeverageList;
  late Future<List<Product>> futureFashionList;
  late bool _isProductsOnCart;
  late int _productsOnCartCount;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _isProductsOnCart = widget.isProductsOnCart;
    _productsOnCartCount = widget.productsOnCartCount;
    futureFoodList = service.retrieveFoodProducts();
    futureBeverageList = service.retrieveBeverageProducts();
    futureFashionList = service.retrieveFashionProducts();
  }

  void _setIsProductOnCart() {
    setState(() {
      _isProductsOnCart = true;
      _productsOnCartCount++;
    });
  }

  void _afterProductRemoved(Product product) {
    setState(() {
      _productsOnCartCount--;
      if (_productsOnCartCount < 1) {
        _isProductsOnCart = false;
      }
    });
  }

  void _onStartScroll() {
    setState(() {
      _isVisible = false;
    });
  }

  void _onStopScroll() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          title: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      SearchScreen(isFavorite: widget.isFavorite,
                          setFavProduct: widget.onIconTapped,
                          addProductToCart: widget.addProductToCart)
              ));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFFE6E7E9)
              ),
              margin: const EdgeInsets.symmetric(vertical: 30),
              padding: const EdgeInsets.symmetric(vertical: 5),
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
          ),
          actions: [
            Image.asset('images/shopping_cart.png', scale: 2),
            const SizedBox(width: 10)
          ],
        ),
        bottomNavigationBar: _isProductsOnCart
            ? ScrollToHideWidget(
            isVisible: _isVisible,
              child: Container(
                alignment: Alignment.center,
                height: 80,
                color: Colors.white.withOpacity(0.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ShoppingCart(productsOnCart: widget.productsOnCart,
                                  removeProductFromCart: widget.removeProductFromCart,
                                  afterProductRemoved: _afterProductRemoved)
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF314797),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 5)),
                    child: Text("$_productsOnCartCount products in cart",
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.background))
                ),
            )
        ) : const SizedBox(),
        body: FutureBuilder(
          future: Future.wait(
              [futureFoodList, futureBeverageList, futureFashionList]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            var foodList = snapshot.data![0];
            var beverageList = snapshot.data![1];
            var fashionList = snapshot.data![2];
            return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollStartNotification) {
                    _onStartScroll();
                  } else if (scrollNotification is ScrollEndNotification) {
                    _onStopScroll();
                  }
                  return true;
                },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    productCardHeader(context, 'Produk Makanan Kami!', "Makanan pilihan kami"),
                    StaticGrid(
                        gap: 4,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        children: [
                          for (var i = 0; i < 4; i++)
                            productCard(
                                context, foodList[i],
                                widget.isFavorite(foodList[i]),
                                widget.onIconTapped, widget.addProductToCart,
                                _setIsProductOnCart
                            )
                        ]),
                    const SizedBox(height: 40),
                    productCardHeader(context, 'Produk Minuman Kami!',
                        "Minuman pilihan kami"),
                    StaticGrid(
                        gap: 4,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        children: [
                          for (var i = 0; i < 4; i++)
                            productCard(
                                context, beverageList[i],
                                widget.isFavorite(beverageList[i]),
                                widget.onIconTapped, widget.addProductToCart,
                                _setIsProductOnCart
                            )
                        ]),
                    const SizedBox(height: 40),
                    productCardHeader(context, 'Produk Fashion Kami!',
                        "Fashion pilihan kami"),
                    StaticGrid(
                        gap: 4,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        children: [
                          for (var fashionProduct in fashionList)
                            productCard(
                                context, fashionProduct,
                                widget.isFavorite(fashionProduct),
                                widget.onIconTapped, widget.addProductToCart,
                                _setIsProductOnCart
                            )
                        ]),
                    const SizedBox(height: 90)
                  ],
                ),
              )
            );
          },
        ));
  }
}
