import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/screens/cart/product_on_cart.dart';
import 'package:vendo/screens/payments/payment_screen.dart';
import 'package:vendo/utils/currency_format.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../models/users.dart';
import '../../models/voucher.dart';
import '../../utils/reusable_widgets.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key, required this.productsOnCart,
    required this.removeProductFromCart, this.afterProductRemoved});

  final List<Product> productsOnCart;
  final void Function(Product, int) removeProductFromCart;
  final void Function(Product)? afterProductRemoved;

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late Future<Users> futureUserData;
  List<int> _priceList = [];
  late List<Product> _productsOnCart;
  int _subtotal = 0;
  double _valueAddedTax = 0;
  int _initialTotalCost = 0;
  int _totalCost = 0;
  bool _isVoucherEnabled = false;
  bool _allFoodOrBeverage = false;
  bool _allFashion = false;
  int _discountPrice = 0;
  final List<Voucher> _vouchers = DummyVoucherData.getVouchers();
  int _selectedVoucherIndex = 20;
  Category productCategory = Category.all;

  Future<void> _handleCheckout() async {
    if (!_allFoodOrBeverage && !_allFashion) {
      _showCategoryExceptionDialog();
    } else {
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  PaymentScreen(subtotal: _subtotal, valueAddedTax: _valueAddedTax,
                      totalCost: _totalCost, isVoucherEnabled: _isVoucherEnabled,
                      discountPrice: _discountPrice, productCategory: productCategory,
                      productsOnCart: widget.productsOnCart)
          )
      );
    }
  }

  void _onDifferentCategoryRemoved() {
    setState(() {
      _allFoodOrBeverage = _productsOnCart.every(
              (product) => product.category == "food" || product.category == "beverage"
      );
      _allFashion = _productsOnCart.every(
              (product) => product.category == "fashion"
      );
    });
  }

  Future<void> _showCategoryExceptionDialog() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Image.asset('images/danger.png', scale: 2.5,),
          surfaceTintColor: Theme.of(context).colorScheme.background,
          actionsAlignment: MainAxisAlignment.spaceBetween,
          content: Text('Produk makanan/minuman dan fashion tidak dapat dibeli '
              'secara bersamaan',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground
              )),
          actions: <Widget>[
            // const Color(0xFF314797)
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4)),
                    child: Text('Tutup',
                        style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF314797)))
                )
            ),
          ],
        );
      },
    );
  }

  Future<void> _showVoucherDialog() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              surfaceTintColor: Theme.of(context).colorScheme.background,
              actionsAlignment: MainAxisAlignment.spaceBetween,
              title: Text('Voucher',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground
                  )),
              content: Column(
                  children: List.generate(_vouchers.length, (index) {
                    return voucherContent(_vouchers[index], index, _selectedVoucherIndex,
                            () {
                          setState(() {
                            _selectedVoucherIndex = index;
                          });
                        });
                  })
              ),
              actions: <Widget>[
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF314797),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 4)),
                        child: Text('Tutup',
                            style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                    )
                ),
              ],
            );
          });
      },
    ).then((value) {
      if (!_allFoodOrBeverage && !_allFashion) {
        debugPrint("You cannot");
      } else {
        _applyOrRemoveVoucher();
      }
    });
  }

  void _applyOrRemoveVoucher() {
    if (_subtotal >= _vouchers[_selectedVoucherIndex].minimumOrder) {
      setState(() {
        _isVoucherEnabled = true;
        _discountPrice = (_subtotal * _vouchers[_selectedVoucherIndex].discountPercentage).toInt();
        if (_discountPrice > _vouchers[_selectedVoucherIndex].maxDiscount) {
          _discountPrice = _vouchers[_selectedVoucherIndex].maxDiscount;
          _totalCost = _initialTotalCost - _discountPrice;
        } else {
          _totalCost = _initialTotalCost - _discountPrice;
        }
      });
    } else {
      setState(() {
        _isVoucherEnabled = false;
        _totalCost = _initialTotalCost;
        _selectedVoucherIndex = 20;
      });
      _showSnackBar(context);
    }
  }

  void _showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Voucher tidak dapat diterapkan',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          )),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _incrementCost(int index, int price, int initialPrice) {
    _priceList[index] = price;
    setState(() {
      _subtotal = _priceList.reduce((a, b) => a + b);
      _valueAddedTax = _subtotal * 0.11;
      _totalCost = _subtotal + _valueAddedTax.toInt() + 1000;
      _initialTotalCost = _totalCost;
    });
    if (_selectedVoucherIndex != 20) {
      _applyOrRemoveVoucher();
    }
  }

  void _decrementCost(int index, int price, int initialPrice) {
    _priceList[index] = price;
    setState(() {
      _subtotal = _priceList.reduce((a, b) => a + b);
      _valueAddedTax = _subtotal * 0.11;
      _totalCost = _subtotal + _valueAddedTax.toInt() + 1000;
      _initialTotalCost = _totalCost;
    });
    if (_selectedVoucherIndex != 20) {
      _applyOrRemoveVoucher();
    }
  }

  void _onProductRemoved(int index, int price) {
    _priceList.removeAt(index);
    _productsOnCart.removeAt(index);
    setState(() {
      if (_priceList.isNotEmpty) {
        _subtotal = _priceList.reduce((a, b) => a + b);
        _valueAddedTax = _subtotal * 0.11;
        _totalCost = _subtotal + _valueAddedTax.toInt() + 1000;
        _initialTotalCost = _totalCost;
      }
      else {
        _subtotal = 0;
        _totalCost = 0;
        _valueAddedTax = 0;
      }
    });
    if (_selectedVoucherIndex != 20) {
      _applyOrRemoveVoucher();
    }
  }

  @override
  void initState() {
    super.initState();
    _productsOnCart = widget.productsOnCart;
    if (_productsOnCart.isNotEmpty) {
      setState(() {
        _priceList = _productsOnCart.map((product) => product.price * product.quantity!).toList();
        _subtotal = _priceList.reduce((a, b) => a + b);
        _valueAddedTax = _subtotal * 0.11;
        _totalCost = _subtotal + _valueAddedTax.toInt() + 1000;
        _initialTotalCost = _totalCost;
      });
    }
    setState(() {
      _allFoodOrBeverage = _productsOnCart.every(
              (product) => product.category == "food" || product.category == "beverage"
      );
      _allFashion = _productsOnCart.every((product) => product.category == "fashion");
    });
    if (!_allFoodOrBeverage && !_allFashion) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _showCategoryExceptionDialog();
      });
    }
    else if (_allFoodOrBeverage) {
      setState(() {
        productCategory = Category.foodOrBeverage;
      });
    } else {
      setState(() {
        productCategory = Category.fashion;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      extendBody: true,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
                onProductRemoved: _onProductRemoved,
                onDifferentCategoryRemoved: _onDifferentCategoryRemoved,
                afterProductRemoved: widget.afterProductRemoved,
              );
          }),
      bottomNavigationBar:
          _productsOnCart.isEmpty ?
          const SizedBox() : shoppingBottomNavBar(context, _subtotal,
              _valueAddedTax, _totalCost, true, _isVoucherEnabled, _handleCheckout,
              _showVoucherDialog, _discountPrice)
    );
  }
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
                  color: const Color(0xFF6B7280))
          )
      )
    ],
  );
}

Widget voucherContent(Voucher voucher, int index, int selectedIndex,
void Function() onVoucherTapped) {
  return GestureDetector(
      onTap: onVoucherTapped,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: index == selectedIndex
              ? const Color(0xFF2A4399)
              : Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                voucher.title,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                )
            ),
            Container(
                margin: const EdgeInsets.only(left: 5, top: 5),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(color: Colors.black,
                          shape: BoxShape.circle),
                    ),
                    Text(
                        "Min. order ${CurrencyFormat.convertToIdr(voucher.minimumOrder)}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF6B7280)
                        )
                    ),
                  ],
                )
            ),
            Container(
                margin: const EdgeInsets.only(left: 5),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(color: Colors.black,
                          shape: BoxShape.circle),
                    ),
                    Text(
                        "Diskon maks. ${CurrencyFormat.convertToIdr(voucher.maxDiscount)}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF6B7280)
                        )
                    ),
                  ],
                )
            ),
          ],
        ),
      )
  );
}
