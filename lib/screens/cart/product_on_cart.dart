import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/product.dart';
import '../../utils/currency_format.dart';

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
  State<ProductOnCart> createState() => _ProductOnCartState();
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

  Future<void> _showRemoveDialog(Product product) async {
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
                    _showRemoveDialog(widget.product);
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