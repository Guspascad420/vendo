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
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const Icon(Icons.arrow_back)),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: const Color(0xFFF4F5F9),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.only(left: 25, top: 5, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.background),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Quantity',
                      style: GoogleFonts.inter(fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF868889))),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            _decrementQuantity();
                          },
                          icon: const Icon(Icons.remove)
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text('$_quantity',
                            style: GoogleFonts.inter(fontSize: 21,
                              fontWeight: FontWeight.w500,)),
                      ),
                      IconButton(
                          onPressed: () {
                            _incrementQuantity();
                          },
                          icon: const Icon(Icons.add)
                      ),
                      const SizedBox(width: 10)
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(height: 20, color: const Color(0xFFF4F5F9)),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 22),
            color: const Color(0xFF2A4399),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Add to cart',
                    style: GoogleFonts.inter(fontSize: 17, color: Colors.white)),
                const SizedBox(width: 10),
                const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 30)
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 115),
                child: Image.network('https://guspascad.blob.core.windows.net/democontainer/'
                    '${widget.product.imageRes}'),
              ),
              productDetailsHeader(context, widget.product),
              const SizedBox(height: 10),
              productDetailsBody('widget.product.description')
            ],
          )
      ),
    );
  }
}

Widget productDetailsHeader(BuildContext context, Product product) {
  int price = product.price;
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Rp $price',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2A4399))),
            const Icon(Icons.favorite_border),
          ],
        ),
        Text(product.name,
            style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground)),
        Row(
          children: [
            Text('4.5',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onBackground)),
            RatingBar.builder(
              itemSize: 25,
              initialRating: 4.5,
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
        ),
      ],
    ),
  );
}

Widget productDetailsBody(String productDescription) {
  return Expanded(
      child: Container(
        width: double.infinity,
        color: const Color(0xFFF4F5F9),
        child: Text(productDescription,
            style: GoogleFonts.inter(
                fontSize: 15,
                color: const Color(0xFF868889))),
      )
  );
}
