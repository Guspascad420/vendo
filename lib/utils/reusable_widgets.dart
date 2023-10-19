import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timelines/timelines.dart';

import '../models/product.dart';
import '../screens/product_details.dart';

TextField reusableTextField(String text, bool isPasswordType,
    TextEditingController controller, [Color? borderColor, double? borderWidth]) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    style: GoogleFonts.inter(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.w500
    ),
    decoration: InputDecoration(
      labelText: text,
      labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.0),
          borderSide: BorderSide(width: borderWidth ?? 1,
              color: borderColor ?? const Color(0xFFBEC5D1))
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.0),
          borderSide: const BorderSide(width: 1, color: Color(0xFF314797))
      ),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Widget productCard(BuildContext context, Product product, List<Product> productsOnCart,
    bool isFavorite,
    void Function(Product) onIconTapped,
    void Function(Product, int) onAddToCart,
    [void Function()? setIsProductOnCart]) {
  var productName = product.name.length > 15
      ? '${product.name.substring(0, 13)}...'
      : product.name;

  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductDetails(product: product, isFavorite: isFavorite,
              productsOnCart: productsOnCart, onIconPressed: onIconTapped,
              onAddToCart: onAddToCart, setIsProductOnCart: setIsProductOnCart)));
    },
    child: Card(
        surfaceTintColor: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          //set border radius more than 50% of height and width to make circle
        ),
        child: Container(
          width: 145,
          margin: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Center(
                    child: Image.network(
                        'https://guspascad.blob.core.windows.net/democontainer/'
                            '${product.imageRes}',
                        scale: 2.2)),
              ),
              const SizedBox(height: 10),
              Text(productName,
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground)),
              Text('Rp. ${product.price}',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280))),
            ],
          ),
        )),
  );
}

Widget productCardHeader(
    BuildContext context, String title, void Function() onTextPressed) {
  return Container(
    padding: const EdgeInsets.only(left: 20, right: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground)),
          Text('Best of the today\'s updated food list',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280)))
        ]),
        Row(
          children: [
            TextButton(
                onPressed: onTextPressed,
                child: Text('See all',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B7280)))),
            const Icon(Icons.arrow_forward_ios_sharp, color: Color(0xFF6B7280))
          ],
        )
      ],
    ),
  );
}

Widget timelineView(int contentIndex) {
  List<String> timelineContent = ["Atur Informasi Toko", "Daftarkan Produk", "Validasi"];
  return Center(
      child: SizedBox(
          height: 70,
          child: FixedTimeline.tileBuilder(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              builder: TimelineTileBuilder.connected(
                  connectionDirection: ConnectionDirection.before,
                  firstConnectorBuilder: (context) => const TransparentConnector(),
                  lastConnectorBuilder: (context)=> const TransparentConnector(),
                  contentsAlign: ContentsAlign.basic,
                  contentsBuilder: (context, index) {
                    return Text(timelineContent[index],
                        style: GoogleFonts.inter(
                            fontSize: 10, color: const Color(0xFF2A4399),
                            fontWeight: FontWeight.bold));
                  },
                  connectorBuilder: (_, index, ___) =>
                  const SolidLineConnector(color: Color(0xFF2A4399)),
                  indicatorBuilder: (context, index) => DotIndicator(
                      color: index > contentIndex? Colors.grey : const Color(0xFF2A4399),
                      size: 30
                  ),
                  itemExtent: 120,
                  itemCount: 3
              )
          )
      )
  );
}