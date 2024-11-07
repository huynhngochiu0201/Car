import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  final CollectionReference _reviewsCollection =
      FirebaseFirestore.instance.collection('reviews');

  Future<void> submitReview({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    try {
      await _reviewsCollection.add({
        'productId': productId,
        'rating': rating,
        'comment': comment,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Error submitting review: $e');
      throw Exception('Failed to submit review');
    }
  }
}
