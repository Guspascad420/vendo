import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/database/database_service.dart';
import 'package:vendo/screens/product_details/review_page.dart';
import 'package:vendo/utils/currency_format.dart';
import '../../models/product.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails(
      {super.key, required this.product,
        required this.onIconPressed, required this.onAddToCart,
        required this.isFavorite, this.setIsProductOnCart});

  final Product product;
  final bool isFavorite;
  final void Function(Product) onIconPressed;
  final void Function(Product, int) onAddToCart;
  final void Function()? setIsProductOnCart;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with SingleTickerProviderStateMixin {
  DatabaseService service = DatabaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);

  int _quantity = 1;
  late bool _isFavorite;

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

  void _setFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void showSnackBar(BuildContext context) {
    String text = _isFavorite ? 'Berhasil menambahkan produk ke favorit'
        : 'Berhasil menghapus produk dari favorit';
    final snackBar = SnackBar(
      content: Text(text,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          )),
      backgroundColor: const Color(0xFF2A4399),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading:  IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)
          )
      ),
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
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF868889))),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            _decrementQuantity();
                          },
                          icon: const Icon(Icons.remove)),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text('$_quantity',
                            style: GoogleFonts.inter(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                      IconButton(
                          onPressed: () {
                            _incrementQuantity();
                          },
                          icon: const Icon(Icons.add)),
                      const SizedBox(width: 10)
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(height: 20, color: const Color(0xFFF4F5F9)),
          GestureDetector(
              onTap: () {
                widget.onAddToCart(widget.product, _quantity);
                if (widget.setIsProductOnCart != null) {
                  widget.setIsProductOnCart!();
                }
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 22),
                color: const Color(0xFF2A4399),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Add to cart',
                        style: GoogleFonts.inter(
                            fontSize: 17, color: Colors.white)),
                    const SizedBox(width: 10),
                    const Icon(Icons.shopping_bag_outlined,
                        color: Colors.white, size: 30)
                  ],
                ),
              ))
        ],
      ),
      body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 115),
                child: Image.network(
                    'https://guspascad.blob.core.windows.net/democontainer/'
                        '${widget.product.imageRes}'),
              ),
              productDetailsHeader(
                  context,
                  widget.product,
                  _isFavorite,
                  _controller,
                  widget.onIconPressed,
                  _setFavorite,
                  showSnackBar
              ),
              const SizedBox(height: 10),
              productDetailsBody('Description goes here')
            ],
          )
      ),
    );
  }
}

Widget productDetailsHeader(
    BuildContext context, Product product, bool isFavorite,
    AnimationController controller,
    void Function(Product) onIconPressed, void Function() setFavorite,
    void Function(BuildContext) showSnackbar
    ) {
  int price = product.price;
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(CurrencyFormat.convertToIdr(price),
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2A4399))),
            GestureDetector(
                onTap: () {
                  onIconPressed(product);
                  setFavorite();
                  controller
                      .reverse()
                      .then((value) => controller.forward());
                  showSnackbar(context);
                },
                child: ScaleTransition(
                        scale: Tween(begin: 0.7, end: 1.0).animate(
                          CurvedAnimation(parent: controller, curve: Curves.easeOut)
                        ),
                        child: isFavorite
                            ? const Icon(Icons.favorite, color: Colors.red)
                            : const Icon(Icons.favorite_border)
                )
            )
          ],
        ),
        Text(product.name,
            style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground)),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ReviewPage(product: product)));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF2A4399)
                ),
                child: Text('4.5',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              )
            ),
            RatingBar(
              itemSize: 25,
              initialRating: 4.5,
              minRating: 1,
              ignoreGestures: true,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              ratingWidget: RatingWidget(
                  full: const Icon(Icons.star, color: Colors.amber,),
                  half: const Icon(Icons.star_half, color: Colors.amber),
                  empty: const Icon(Icons.star_border)
              ),
              onRatingUpdate: (rating) {},
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        color: const Color(0xFFF4F5F9),
        child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam '
            'dictum massa lorem, sit amet pulvinar arcu imperdiet mollis. '
            'Duis sed elementum magna. Vivamus eget est tortor. Morbi dolor dolor,',
        style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF868889))),
  ));
}
