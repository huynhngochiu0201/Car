import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String userEmail;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final bool isVerifiedPurchase;
  final DateTime timestamp;
  final DateTime updatedAt;
  final String userAvatar;

  ReviewModel({
    required this.id,
    required this.userEmail,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.isVerifiedPurchase,
    required this.timestamp,
    required this.updatedAt,
    required this.userAvatar,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json, String id) {
    return ReviewModel(
      id: id,
      userEmail: json['userEmail'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      isVerifiedPurchase: json['isVerifiedPurchase'] ?? false,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      userAvatar: json['userAvatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'isVerifiedPurchase': isVerifiedPurchase,
      'timestamp': Timestamp.fromDate(timestamp),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'userAvatar': userAvatar,
    };
  }
}
