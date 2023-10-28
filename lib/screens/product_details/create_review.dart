import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/database/database_service.dart';
import 'package:vendo/models/review.dart';
import 'package:vendo/screens/main/main_screen.dart';
import 'package:vendo/screens/product_details/review_page.dart';
import '../../models/product.dart';
import '../../models/users.dart';

class CreateReview extends StatefulWidget {
  const CreateReview({super.key, required this.product});

  final Product product;

  @override
  State<CreateReview> createState() => _CreateReviewState();

}

class _CreateReviewState extends State<CreateReview> {
  final TextEditingController _descriptionTextController = TextEditingController();
  double _userRating = 1;
  DatabaseService service = DatabaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  late Future<Users> userData;
  String _username = "";

  @override
  void initState() {
    super.initState();
    userData = service.retrieveUserData(auth.currentUser!.uid);
    userData.then((data) => setState(() {
      _username = data.fullName;
    }));
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
      bottomNavigationBar: Wrap(
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Review review = Review(_username, _userRating, _descriptionTextController.text);
                  service.addUserReview(review);
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A4399),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 12
                    )
                ),
                child: Text('Tambah Review',
                    style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.background
                    ))
            ),
            const SizedBox(height: 20)
          ],
        ),
      body: Center(
        child: Column(
          children: [
            Image.network("https://guspascad.blob.core.windows.net/democontainer/"
                "${widget.product.imageRes}", scale: 1.2),
            Text(widget.product.name,
                style: GoogleFonts.inter(fontSize: 25,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 15),
            RatingBar(
              itemSize: 40,
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              ratingWidget: RatingWidget(
                  full: const Icon(Icons.star, color: Colors.amber,),
                  half: const Icon(Icons.star_half, color: Colors.amber),
                  empty: const Icon(Icons.star_border)
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _userRating = rating;
                });
              },
            ),
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
               keyboardType: TextInputType.multiline,
               maxLines: null,
               decoration: InputDecoration(
                   labelText: "Berikan Komentar...",
                   floatingLabelBehavior: FloatingLabelBehavior.never,
                   enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(17.0),
                       borderSide: const BorderSide(width: 1,
                           color: Color(0xFFBEC5D1))
                   ),
                   focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(17.0),
                       borderSide: const BorderSide(width: 1,
                           color: Color(0xFF314797))
                   )
               ),
             ),
            )
          ],
        )
      ),
    );
  }
}