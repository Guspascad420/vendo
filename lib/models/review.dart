import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String? id;
  final String reviewer;
  final double rating;
  final String description;

  const Review(this.reviewer, this.rating, this.description, [this.id]);

  Map<String, dynamic> toMap() {
    return {
      'reviewer': reviewer,
      'rating': rating,
      'description': description,
    };
  }

  Review.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
    : id = doc.id,
      reviewer = doc.data()!["reviewer"],
      rating = doc.data()!["rating"],
      description = doc.data()!["description"];
}