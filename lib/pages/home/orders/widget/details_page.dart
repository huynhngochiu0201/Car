import 'package:app_car_rescue/components/app_bar/custom_app_bar.dart';
import 'package:app_car_rescue/components/button/cr_elevated_button.dart';
import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/resources/double_extension.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:app_car_rescue/pages/home/orders/rating/rating_bar_custom.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../gen/assets.gen.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;
  final String sourcePage;

  // Định nghĩa cartData tại đây để toàn bộ class có thể sử dụng
  final List<Map<String, dynamic>> cartData;

  DetailsPage({super.key, required this.order, required this.sourcePage})
      : cartData = List<Map<String, dynamic>>.from(order['cartData'] ?? []);

  @override
  Widget build(BuildContext context) {
    final String address = order['address'];
    final double totalPrice = order['totalPrice'] ?? 0.0;

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
                padding: const EdgeInsets.symmetric(horizontal: 20.0)
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Delivery address: $address ',
                                    style: AppStyle.bold_14,
                                  ),
                                  spaceH10,
                                  Row(
                                    children: [
                                      Text('Total: ', style: AppStyle.bold_14),
                                      Text(totalPrice.toVND(),
                                          style: AppStyle.bold_14),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          spaceH10,
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartData.length,
                            itemBuilder: (context, index) {
                              var product = cartData[index];
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
    if (sourcePage == 'PendingPage') {
      return 'Cancel';
    } else if (sourcePage == 'CancelledPage') {
      return 'Reorder';
    } else {
      return 'Rate';
    }
  }

  void _handleButtonAction(BuildContext context) {
    if (sourcePage == 'PendingPage') {
      _cancelOrder();
    } else if (sourcePage == 'CancelledPage') {
      _reorderProducts(context);
    } else if (sourcePage == 'DeliveredPage') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RatingBarCustom(
            products: cartData,
          ),
        ),
      );
    }
  }

  void _cancelOrder() {
    print('Order cancelled');
  }

  void _reorderProducts(BuildContext context) {
    print('Reorder products');
  }
}
