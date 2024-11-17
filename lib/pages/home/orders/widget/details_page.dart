import 'package:app_car_rescue/components/app_bar/custom_app_bar.dart';
import 'package:app_car_rescue/components/button/cr_elevated_button.dart';
import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/pages/home/orders/rating/review_rating.dart';
import 'package:app_car_rescue/resources/double_extension.dart';
import 'package:app_car_rescue/services/remote/cart_service.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../models/cart_model.dart';
import '../../cart/cart_page.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> order;
  final String sourcePage;
  final List<Map<String, dynamic>> cartData;

  DetailsPage({super.key, required this.order, required this.sourcePage})
      : cartData = List<Map<String, dynamic>>.from(order['cartData'] ?? []);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Future<void> addProductToCart(Map<String, dynamic> product) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('carts')
            .doc(user.uid)
            .collection('items')
            .add({
          'productId': product['productId'],
          'productName': product['productName'],
          'productPrice': product['productPrice'],
          'productImage': product['productImage'],
          'quantity': product['quantity'],
          'createdAt': Timestamp.now(),
        });
      }
    } catch (e) {
      throw Exception('Failed to add product to cart: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String address = widget.order['address'];
    final double totalPrice = widget.order['totalPrice'] ?? 0.0;

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: 'Order Details'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 92.0,
              decoration: BoxDecoration(
                color: AppColor.E575757.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0)
                    .copyWith(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your order is delivered',
                          style:
                              AppStyle.bold_16.copyWith(color: AppColor.white),
                        ),
                        Text(
                          'We appreciate your positive feedback.',
                          style: AppStyle.semibold_11,
                        ),
                      ],
                    ),
                    SvgPicture.asset(Assets.icons.cartt),
                  ],
                ),
              ),
            ),
            spaceH20,
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0)
                          .copyWith(top: 10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Address: $address ',
                                      style: AppStyle.bold_14,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    spaceH10,
                                    Row(
                                      children: [
                                        Text('Total: ',
                                            style: AppStyle.bold_14),
                                        Text(totalPrice.toVND(),
                                            style: AppStyle.bold_14),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          spaceH10,
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.cartData.length,
                            itemBuilder: (context, index) {
                              var product = widget.cartData[index];
                              return GestureDetector(
                                onTap: () {
                                  // Handle tap on product item here, e.g., show product details
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 70.0,
                                        height: 70.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                product['productImage']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                                  horizontal: 10.0)
                                              .copyWith(bottom: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product['productName'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppStyle.bold_14,
                                              ),
                                              const SizedBox(height: 8.0),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  'x ${product['quantity']}',
                                                  style: AppStyle.bold_12,
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  NumberFormat.currency(
                                                          symbol: 'VND ',
                                                          decimalDigits: 0)
                                                      .format(product[
                                                          'productPrice']),
                                                  style: AppStyle.bold_12,
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CrElevatedButton(
                    width: 150.0,
                    text: 'Return Home',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CrElevatedButton(
                    width: 150.0,
                    text: _getButtonText(),
                    onPressed: () {
                      _handleButtonAction(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonText() {
    if (widget.sourcePage == 'PendingPage') {
      return 'Cancel';
    } else if (widget.sourcePage == 'CancelledPage') {
      return 'Reorder';
    } else {
      return 'Rate';
    }
  }

  void _handleButtonAction(BuildContext context) {
    if (widget.sourcePage == 'PendingPage') {
      _cancelOrder(context);
    } else if (widget.sourcePage == 'CancelledPage') {
      _reorderProducts(context);
    } else if (widget.sourcePage == 'DeliveredPage') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewRating(
            products: widget.cartData,
          ),
        ),
      );
    }
  }

  void _cancelOrder(BuildContext context) {
    // Hộp thoại xác nhận hủy đơn hàng
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Cancellation'),
          content: const Text('Are you sure you want to cancel this order?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                try {
                  // Lấy orderId và cập nhật trạng thái
                  String? orderId = widget.order['orderId'];
                  if (orderId != null && orderId.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(orderId)
                        .update({'status': 'Cancelled'});

                    // Thông báo hủy thành công
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order has been cancelled'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.of(context).pop(); // Đóng hộp thoại
                    Navigator.of(context).pop(); // Trở lại trang trước
                  } else {
                    throw 'Order ID not found';
                  }
                } catch (e) {
                  // Thông báo lỗi nếu thất bại
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to cancel order: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _reorderProducts(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final cartService = CartService();
      for (var product in widget.cartData) {
        await cartService.addToCart(CartModel(
          userId: user?.uid ?? '',
          productId: product['productId'],
          productName: product['productName'],
          productPrice: product['productPrice'],
          productImage: product['productImage'],
          quantity: product['quantity'],
        ));
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartPage()),
      );
    } catch (e) {
      print('Error: $e');
    }
  }
}
