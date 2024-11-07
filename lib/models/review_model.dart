import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String userId;
  final String productId;
  final double rating;
  final String comment;
  final Timestamp timestamp;

  Review({
    required this.userId,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  // Convert a Review object to JSON format for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'productId': productId,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp,
    };
  }

  // Create a Review object from JSON data from Firestore
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userId: json['userId'] as String,
      productId: json['productId'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      timestamp: json['timestamp'] as Timestamp,
    );
  }
}
