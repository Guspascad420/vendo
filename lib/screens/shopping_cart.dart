import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/utils/currency_format.dart';
import '../models/product.dart';
import '../models/users.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key, required this.productsOnCart,
    required this.removeProductFromCart, this.afterProductRemoved});

  final List<Product> productsOnCart;
  final void Function(Product, int) removeProductFromCart;
  final void Function(Product)? afterProductRemoved;

  @override
  State<StatefulWidget> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late Future<Users> futureUserData;
  List<int> _priceList = [];
  late List<Product> _productsOnCart;
  int _subtotal = 0;
  double _valueAddedTax = 0;
  int _totalCost = 0;

  void _incrementCost(int index, int price, int initialPrice) {
    _priceList[index] = price;
    setState(() {
      _subtotal = _priceList.reduce((a, b) => a + b);
      _valueAddedTax = _subtotal * 0.11;
      _totalCost = _subtotal + _valueAddedTax.toInt() + 1000;
    });
  }

  void _decrementCost(int index, int price, int initialPrice) {
    _priceList[index] = price;
    setState(() {
      _subtotal = _priceList.reduce((a, b) => a + b);
      _valueAddedTax = _subtotal * 0.11;
      _totalCost = _subtotal + _valueAddedTax.toInt() + 1000;
    });
  }

  void onProductRemoved(int index, int price) {
    _priceList.removeAt(index);
    _productsOnCart.removeAt(index);
    setState(() {
      if (_priceList.isNotEmpty) {
        _subtotal = _priceList.reduce((a, b) => a + b);
        _valueAddedTax = _subtotal * 0.11;
        _totalCost = _subtotal + _valueAddedTax.toInt() + 1000;
        //12100
      }
      else {
        _subtotal = 0;
        _totalCost = 0;
        _valueAddedTax = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
      _productsOnCart = widget.productsOnCart;
      if (_productsOnCart.isNotEmpty) {
        setState(() {
          _priceList = _productsOnCart.map((product) => product.price).toList();
          _subtotal = _priceList.reduce((a, b) => a + b);
          _valueAddedTax = _subtotal * 0.11;
          _totalCost = _subtotal + _valueAddedTax.toInt() + 1000;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)
          ),
          surfaceTintColor: Colors.white,
          title: Text('Keranjang Belanja',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground)),
          centerTitle: true
      ),
      body: _productsOnCart.isEmpty
          ? emptyCart(context)
          : ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 10),
            itemCount: _productsOnCart.length,
            itemBuilder: (BuildContext context, int index) {
              return ProductOnCart(
                index: index,
                product: _productsOnCart[index],
                incrementCost: _incrementCost,
                decrementCost: _decrementCost,
                removeProductFromCart: widget.removeProductFromCart,
                onProductRemoved: onProductRemoved,
                afterProductRemoved: widget.afterProductRemoved,
              );
          }),
      bottomNavigationBar:
          _productsOnCart.isEmpty ?
          const SizedBox() : bottomNavBar(context, _subtotal, _valueAddedTax, _totalCost),
    );
  }
}

Widget bottomNavBar(BuildContext context, int subtotal, double valueAddedTax, int totalCost) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Center(
        child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF314797),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 70, vertical: 5)),
            child: Text('Voucher',
                style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.background)))
      ),
      const Divider(),
      const SizedBox(height: 10),
      costsContent('Subtotal', subtotal),
      const SizedBox(height: 10),
      costsContent('Tax 11%', valueAddedTax.toInt()),
      const SizedBox(height: 10),
      costsContent('Biaya layanan', 1000),
      const Divider(),
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
                  style: GoogleFonts.inter(
                      fontSize: 21,
                      fontWeight: FontWeight.w600)),
              Text(CurrencyFormat.convertToIdr(totalCost),
                  style: GoogleFonts.inter(
                      fontSize: 21,
                      fontWeight: FontWeight.w600))
            ],
          )
      ),
      GestureDetector(
          onTap: () {

          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 22),
            color: const Color(0xFF2A4399),
            child: Text('Checkout',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 18, color: Colors.white))
          )
      )
    ],
  );
}

Widget costsContent(String title, int cost) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF868889))),
        Text(CurrencyFormat.convertToIdr(cost),
            style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF868889)))
      ],
    )
  );
}

Widget emptyCart(BuildContext context) {
  return Column(
    children: [
      SizedBox(height: MediaQuery.of(context).size.height * 0.18),
      Image.asset('images/empty_cart.png', scale: 3),
      Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
              'Wah, keranjang belanjamu kosong Yuk, telusuri produk UMKM pilihan kami!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280))))
    ],
  );
}

class ProductOnCart extends StatefulWidget {
  const ProductOnCart(
      {super.key, required this.product, required this.index,
        required this.incrementCost, required this.decrementCost,
        required this.removeProductFromCart,
        required this.onProductRemoved,
        this.afterProductRemoved});

  final Product product;
  final int index;
  final void Function(int, int, int) incrementCost;
  final void Function(int, int, int) decrementCost;
  final void Function(Product, int) removeProductFromCart;
  final void Function(int, int) onProductRemoved;
  final void Function(Product)? afterProductRemoved;

  @override
  State<StatefulWidget> createState() => _ProductOnCartState();
}

class _ProductOnCartState extends State<ProductOnCart> {
  int _quantity = 0;
  late int _price;

  @override
  void initState() {
    super.initState();
    _quantity = widget.product.quantity!;
    _price = widget.product.price * _quantity;
  }

  Future<void> _showDialog(Product product) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
                  widget.onProductRemoved(widget.index, _price);
                  if (widget.afterProductRemoved != null) {
                    widget.afterProductRemoved!(widget.product);
                  }
                  widget.removeProductFromCart(widget.product, _quantity);
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

  void _incrementQty() {
    setState(() {
      _quantity++;
      _price = widget.product.price * _quantity;
    });
    widget.incrementCost(widget.index, _price, widget.product.price);
  }

  void _decrementQty() {
    int previousQuantity = _quantity;
    setState(() {
      if (_quantity > 1) {
        _quantity--;
        _price = widget.product.price * _quantity;
      }
    });
    if (previousQuantity > 1) {
      widget.decrementCost(widget.index, _price, widget.product.price);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  'https://guspascad.blob.core.windows.net/democontainer/'
                  '${widget.product.imageRes}',
                  scale: 5,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(CurrencyFormat.convertToIdr(widget.product.price),
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2A4399))),
                    SizedBox(
                      width: 150,
                      child: Text(widget.product.name,
                            style: GoogleFonts.inter(
                                fontSize: 17, fontWeight: FontWeight.bold))
                    ),
                    Text('600ml',
                        style: GoogleFonts.inter(
                            fontSize: 15, color: const Color(0xFF868889)))
                  ])
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    _showDialog(widget.product);
                  },
                  icon: SvgPicture.asset('images/trash.svg')
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: _incrementQty,
                        icon: const Icon(Icons.add, color: Color(0xFF2A4399))),
                    Text(_quantity.toString(),
                        style: GoogleFonts.inter(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    IconButton(
                        onPressed: _decrementQty,
                        icon:
                            const Icon(Icons.remove, color: Color(0xFF2A4399)))
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
