import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/product.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.product});

  final Product product;

  @override
  State<StatefulWidget> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _quantity = 0;

  void _incrementQuantity() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _quantity++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const Icon(Icons.arrow_back)),
      bottomNavigationBar: Container(
        color: const Color(0xFF2A4399),
        child: Row(
          children: [
            const Icon(Icons.shopping_bag_outlined),
            Text('Add to cart',
                style: GoogleFonts.inter(fontSize: 17, color: Colors.white))
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFF2FFE6),
            child: Image.asset(widget.product.imageRes),
          ),
          productDetailsHeader(context, widget.product),
          const SizedBox(height: 10),

        ],
      ),
    );
  }
}

Widget productDetailsHeader(BuildContext context, Product product) {
  int price = product.price;
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Rp $price',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A4399))),
            const Icon(Icons.favorite_border),
          ],
        ),
        Text(product.name,
            style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onBackground)),
        Row(
          children: [
            Text('4.5',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onBackground)),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              ignoreGestures: true,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) { },
            )
          ],
        )
      ],
    ),
  );
}

Widget productDetailsBody(String productDescription, int quantity, void Function() incrementQuantity) {
  return Container(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Text('sjksdj')
      ],
    ),
  );
}
