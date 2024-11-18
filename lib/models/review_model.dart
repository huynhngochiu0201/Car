import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String userEmail;
  final String productId;
  final double rating;
  final String comment;
  final String userName;
  final String userAvatar;
  final DateTime timestamp;

  ReviewModel({
    required this.userName,
    required this.userAvatar,
    required this.userEmail,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      userEmail: json['userEmail'] ?? '',
      productId: json['productId'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      timestamp: json['timestamp'] != null
          ? (json['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userAvatar': userAvatar,
      'userEmail': userEmail,
      'productId': productId,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp,
    };
  }
}
