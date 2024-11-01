class CartModel {
  final int? id;
  final String userId;
  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final int quantity;
  bool isChecked; // biến checkbox trạng thái

  CartModel({
    this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.quantity,
    this.isChecked = false,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['userId'],
      productId: json['productId'],
      productName: json['productName'],
      productImage: json['productImage'],
      productPrice:
          json['productPrice'].toDouble(), // Đảm bảo chuyển đổi thành double
      quantity: json['quantity'],
      isChecked: json['isChecked'] ??
          false, // Thêm trường isChecked, mặc định là false nếu không tồn tại
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'productPrice': productPrice,
      'quantity': quantity,
      'isChecked': isChecked, // Thêm trường isChecked để lưu trạng thái
    };
  }
}
