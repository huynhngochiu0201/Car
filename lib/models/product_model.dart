import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String categoryId;
  final String name;
  final String image;
  final double price;
  final String description;
  final int viewCount;
  final int orderCount;
  final int quantity;
  final int? favourute;
  final Timestamp? createAt;

  ProductModel(
      {required this.id,
      required this.categoryId,
      required this.name,
      required this.image,
      required this.price,
      required this.description,
      required this.viewCount,
      required this.orderCount,
      this.favourute,
      required this.quantity,
      this.createAt});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json['id'],
        categoryId: json['categoryId'],
        name: json['name'],
        image: json['image'],
        price: json['price'].toDouble(),
        description: json['description'],
        viewCount: json['viewCount'],
        orderCount: json['orderCount'],
        quantity: json['quantity'],
        favourute: json['favourute'],
        createAt: json['createAt']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'name': name,
        'image': image,
        'price': price,
        'description': description,
        'viewCount': 0,
        'orderCount': 0,
        'quantity': quantity,
        'favourute': 0,
        'createAt': Timestamp.now(),
      };
}
