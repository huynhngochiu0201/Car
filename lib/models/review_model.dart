import 'package:cloud_firestore/cloud_firestore.dart';

// class ReviewModel {
//   final String userId;
//   final String userName;
//   final String productId;
//   final double rating;
//   final String comment;
//   final Timestamp timestamp;

//   ReviewModel({
//     required this.userId,
//     required this.userName,
//     required this.productId,
//     required this.rating,
//     required this.comment,
//     required this.timestamp,
//   });

//   // Convert a Review object to JSON format for Firestore
//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'userName': userName,
//       'productId': productId,
//       'rating': rating,
//       'comment': comment,
//       'timestamp': timestamp,
//     };
//   }

//   // Create a Review object from JSON data from Firestore
//   factory ReviewModel.fromJson(Map<String, dynamic> json) {
//     return ReviewModel(
//       userId: json['userId'] as String,
//       userName: json['userName'] as String,
//       productId: json['productId'] as String,
//       rating: (json['rating'] as num).toDouble(),
//       comment: json['comment'] as String,
//       timestamp: json['timestamp'] as Timestamp,
//     );
//   }
// }

class ReviewModel {
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final Timestamp timestamp;

  ReviewModel({
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userId: json['userId'] ?? 'Unknown',
      userName: json['userName'] ?? 'Anonymous',
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] ?? '',
      timestamp: json['timestamp'] as Timestamp,
    );
  }
}
