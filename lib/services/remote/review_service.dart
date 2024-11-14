import 'package:app_car_rescue/models/review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách reviews của sản phẩm
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to load reviews: $e');
    }
  }

  Future<void> submitReview({
    required String userEmail,
    required String productId,
    required double rating,
    required String comment,
  }) async {
    try {
      // Truy cập subcollection 'reviews' trong sản phẩm có ID productId
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .add({
        'userEmail': userEmail,
        'rating': rating,
        'comment': comment,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Error submitting review: $e');
      throw Exception('Failed to submit review');
    }
  }

  // Lấy thống kê rating
  Future<Map<String, dynamic>> getProductRatingStats(String productId) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .get();

      double totalRating = 0;
      Map<int, int> ratingDistribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

      for (var doc in snapshot.docs) {
        double rating = doc.data()['rating'].toDouble();
        totalRating += rating;
        ratingDistribution[rating.round()] =
            (ratingDistribution[rating.round()] ?? 0) + 1;
      }

      return {
        'averageRating':
            snapshot.docs.isEmpty ? 0.0 : totalRating / snapshot.docs.length,
        'totalReviews': snapshot.docs.length,
        'ratingDistribution': ratingDistribution,
      };
    } catch (e) {
      throw Exception('Failed to load rating stats: $e');
    }
  }
}
