import 'package:app_car_rescue/models/review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  // Thêm đánh giá vào subcollection 'reviews' trong tài liệu của sản phẩm
  Future<void> submitReview({
    required String userId,
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
        'userId': userId,
        'rating': rating,
        'comment': comment,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Error submitting review: $e');
      throw Exception('Failed to submit review');
    }
  }

  // Lấy danh sách đánh giá từ subcollection 'reviews' trong sản phẩm có ID productId
  Future<List<ReviewModel>> getReviews(String productId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('reviews')
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
