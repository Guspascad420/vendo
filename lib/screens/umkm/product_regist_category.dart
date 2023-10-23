import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/models/category.dart';
import 'package:vendo/screens/umkm/product_regist.dart';
import 'package:vendo/utils/reusable_widgets.dart';

class ProductRegistCategory extends StatelessWidget {
  const ProductRegistCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          surfaceTintColor: Colors.white,
          title: Text('Daftarkan Produk',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground)),
          centerTitle: true
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            timelineView(1),
            const SizedBox(height: 45),
            Text("Kategori",
                style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                categoryCard(context, Category.foodOrBeverage, 'images/food_or_drinks.png'),
                const SizedBox(width: 7),
                categoryCard(context, Category.fashion, 'images/fashion.png')
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget categoryCard(BuildContext context, Category category, String imageRes) {
  String title = category == Category.foodOrBeverage
      ? "Makanan / Minuman" : "Fashion";
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductRegist(category: category)));
    },
    child: Card(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        //set border radius more than 50% of height and width to make circle
      ),
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          children: [
            Image.asset(imageRes, scale: 2,),
            const SizedBox(height: 5),
            Text(title,
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold))
          ],
        )
      )
    ),
  );
}