import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String name;
  final String address;
  final String phone;
  final String note;
  final String nameservice;
  final String? area;
  final String? payload;
  final String? wheelSize;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
  final String? userId;

  ServiceModel({
    required this.name,
    required this.address,
    required this.phone,
    required this.note,
    required this.nameservice,
    this.area,
    this.payload,
    this.wheelSize,
    required this.totalPrice,
    required this.createdAt,
    required this.status,
    this.userId,
  });

  factory ServiceModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ServiceModel(
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      note: data['note'] ?? '',
      nameservice: data['nameservice'] ?? '',
      area: data['area'],
      payload: data['payload'],
      wheelSize: data['wheelSize'],
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.parse(data['createdAt']),
      status: data['status'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'note': note,
      'nameservice': nameservice,
      'area': area,
      'payload': payload,
      'wheelSize': wheelSize,
      'totalPrice': totalPrice,
      'createdAt':
          createdAt, // Firestore tự động chuyển DateTime thành Timestamp
      'status': status,
      'userId': userId,
    };
  }
}
