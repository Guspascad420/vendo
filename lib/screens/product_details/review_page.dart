import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/models/database_service.dart';
import 'package:vendo/screens/product_details/create_review.dart';

import '../../models/product.dart';
import '../../models/review.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key, required this.product});

  final Product product;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late Future<List<Review>> futureDummyReviews;
  DatabaseService service = DatabaseService();

  @override
  void initState() {
    super.initState();
    futureDummyReviews = service.retrieveDummyReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)
          )
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreateReview(product: widget.product)
                    )
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A4399),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 17)
                ),
                child: Text('Berikan Review',
                    style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.background
                    ))
            )
          ],
        )
      ),
      body: FutureBuilder(
          future: futureDummyReviews,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var reviews = snapshot.data!;
              return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 20),
                  itemCount: reviews.length,
                  itemBuilder: (BuildContext context, int index) {
                    return reviewContent(reviews[index]);
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2A4399)),
            );
          }
      )
    );
  }
}

Widget reviewContent(Review review) {
  return Container(
     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
     margin: const EdgeInsets.symmetric(horizontal: 15),
     decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFF4F5F9)
      ),
     height: 125,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(review.reviewer,
            style: GoogleFonts.inter(fontSize: 23,
                fontWeight: FontWeight.bold)),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF2A4399)
              ),
              child: Text(review.rating.toString(),
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            RatingBar(
              itemSize: 25,
              initialRating: review.rating,
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
        const SizedBox(height: 5),
        Text(review.description,
            style: GoogleFonts.inter(fontSize: 15))
      ],
    )
  );
}
