import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String userEmail;
  final String productId;
  final double rating;
  final String comment;
  final DateTime timestamp;

  ReviewModel({
    required this.id,
    required this.userEmail,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
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
      'id': id,
      'userEmail': userEmail,
      'productId': productId,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp,
    };
  }
}
