import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/models/users.dart';
import 'package:vendo/screens/favorite_screen.dart';
import 'package:vendo/screens/main/home_screen.dart';
import 'package:vendo/screens/main/order_history.dart';
import 'package:vendo/screens/main/profile_screen.dart';
import 'package:vendo/screens/cart/shopping_cart.dart';

import '../../models/database_service.dart';
import '../../models/product.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DatabaseService service = DatabaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  late Future<Users> futureUserData;
  List<Product> _favProducts = [];
  List<Product> _productsOnCart = [];
  List<Widget> bodyWidgetOptions = <Widget> [];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool isFavorite(Product product) {
    var filteredProduct = _favProducts.where((item) => item.id == product.id)
        .toList();
    return filteredProduct.isNotEmpty;
  }

  void setFavProduct(Product product) {
    if (!isFavorite(product)) {
      service.addProductToFavorite(auth.currentUser!.email.toString(), product);
      setState(() {
        _favProducts.add(product);
      });
    } else {
      service.removeProductFromFavorite(auth.currentUser!.email.toString(), product);
      setState(() {
        _favProducts.remove(product);
      });
    }
  }

  void removeFavProduct(Product product) {
    service.removeProductFromFavorite(
        auth.currentUser!.email.toString(),
        product
    );
    setState(() {
      _favProducts.remove(product);
    });
  }

  void addProductToCart(Product product, int quantity) {
    var filteredProduct = _productsOnCart.where((item) => item.id == product.id)
        .toList();
    if (filteredProduct.isEmpty) {
      service.addProductToCart(auth.currentUser!.email.toString(),
          product, quantity);
      var productMap = product.toCartMap(quantity);
      setState(() {
        _productsOnCart.add(Product.toProductOnCart(productMap));
      });
    }
  }

  void removeProductFromCart(Product product, int quantity) {
    service.removeProductFromCart(auth.currentUser!.email.toString(),
        product, quantity);
    setState(() {
      _productsOnCart.remove(product);
    });
  }

  @override
  void initState() {
    super.initState();
    futureUserData =
        service.retrieveUserData(auth.currentUser!.email.toString());
    futureUserData.then((user) => setState(() {
      _favProducts = user.favProducts
          .map((product) => Product.toFavProduct(product))
          .toList();
      _productsOnCart = user.productsOnCart
          .map((product) => Product.toProductOnCart(product))
          .toList();
    }));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyWidgetOptions = <Widget> [
      HomeScreen(favProducts: _favProducts, productsOnCart: _productsOnCart,
          setFavProduct: setFavProduct, addProductToCart: addProductToCart,
          isFavorite: isFavorite, removeProductFromCart: removeProductFromCart),
      const OrderHistory(),
      ProfileScreen(futureUserData: futureUserData),
    ];

    List<PreferredSizeWidget> appBarWidgetOptions = <PreferredSizeWidget>[
      homeAppBar(context, _favProducts, _productsOnCart, removeFavProduct, removeProductFromCart,
      addProductToCart),
      orderHistoryAppBar(context),
      profileAppBar(context)
    ];

    return Scaffold(
        appBar: appBarWidgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset('images/ic_home.svg',
                          color: const Color(0xFFBABABB)),
                      activeIcon: SvgPicture.asset('images/ic_home.svg'),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset('images/ic_orders.svg',
                        color: const Color(0xFFBABABB)),
                      activeIcon: SvgPicture.asset('images/ic_orders.svg',
                          color: const Color(0xFF2A4399)),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset('images/ic_profile.svg',
                          color: const Color(0xFFBABABB)),
                      activeIcon: SvgPicture.asset('images/ic_profile.svg',
                          color: const Color(0xFF2A4399)),
                      label: '')
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            )),
        body: bodyWidgetOptions.elementAt(_selectedIndex));
  }
}

PreferredSizeWidget homeAppBar(BuildContext context, List<Product> favProducts,
    List<Product> productsOnCart,
    void Function(Product) removeFavProduct,
    void Function(Product, int) removeProductFromCart,
    void Function(Product, int) addProductToCart) {
  return AppBar(
    surfaceTintColor: Colors.white,
    leading: const SizedBox(),
    backgroundColor: Theme.of(context).colorScheme.background,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_on, color: Color(0xFF314797)),
        const SizedBox(width: 4),
        Text('Universitas Brawijaya',
            style:
                GoogleFonts.inter(fontSize: 16, color: const Color(0xFF4B5563)))
      ],
    ),
    actions: [
      GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>
                    FavoriteScreen(favProducts: favProducts,
                      removeFavProduct: removeFavProduct,
                      onAddToCart: addProductToCart, productsOnCart: productsOnCart,
                        removeProductFromCart: removeProductFromCart))
            );
          },
          child: const Icon(Icons.favorite_border, color: Color(0xFF314797))),
      const SizedBox(width: 10),
      GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>
                    ShoppingCart(productsOnCart: productsOnCart,
                        removeProductFromCart: removeProductFromCart))
            );
          },
          child: Image.asset('images/shopping_cart.png', scale: 2)),
      const SizedBox(width: 10)
    ],
  );
}

PreferredSizeWidget orderHistoryAppBar(BuildContext context) {
  return AppBar(
      surfaceTintColor: Colors.white,
      title: Text('Riwayat Pemesanan',
          style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground)),
      centerTitle: true);
}

PreferredSizeWidget profileAppBar(BuildContext context) {
  return AppBar(
      surfaceTintColor: Colors.white,
      title: Text('Profil',
          style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground)),
      centerTitle: true);
}
