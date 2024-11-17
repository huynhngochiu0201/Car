import 'package:app_car_rescue/models/review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách reviews của sản phẩm
  Future<List<ReviewModel>> getReviewsByProductId(String productId) async {
    try {
      final snapshot = await _firestore
          .collectionGroup(
              'reviews') // Truy vấn subcollection 'reviews' của tất cả sản phẩm
          .where('productId', isEqualTo: productId) // Điều kiện theo productId
          .get();

      // Chuyển đổi các document trong snapshot thành list ReviewModel
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Gán ID cho mỗi review nếu cần
        return ReviewModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load reviews for product $productId: $e');
    }
  }

  Future<void> addReview({
    required String userId,
    required String userEmail,
    required String productId,
    required double rating,
    required String comment,
    // required String userName,
    // required String userAvatar,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .add({
        'userId': userId,
        'userEmail': userEmail,
        'productId': productId,
        'rating': rating,
        'comment': comment,
        // 'userName': userName,
        // 'userAvatar': userAvatar,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }
}
