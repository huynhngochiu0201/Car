import 'package:app_car_rescue/models/review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  final CollectionReference _reviewsCollection =
      FirebaseFirestore.instance.collection('reviews');

  Future<void> submitReview({
    required String userId,
    required String productId,
    required double rating,
    required String comment,
  }) async {
    try {
      await _reviewsCollection.add({
        'userId': userId,
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

  Future<List<ReviewModel>> getReviews(String productId) async {
    try {
      QuerySnapshot querySnapshot = await _reviewsCollection
          .where('productId', isEqualTo: productId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map(
              (doc) => ReviewModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching reviews: $e');
      throw Exception('Failed to fetch reviews');
    }
  }
}
