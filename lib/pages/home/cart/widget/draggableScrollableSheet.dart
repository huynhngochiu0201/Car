import 'package:app_car_rescue/resources/double_extension.dart';
import 'package:flutter/material.dart';
import '../../../../components/button/cr_elevated_button.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_style.dart';
import '../../../../models/cart_model.dart';
import '../../../../utils/spaces.dart';
import '../checkouts/checkouts_page.dart';

class DraggbleScrollable extends StatelessWidget {
  const DraggbleScrollable({
    super.key,
    required Stream<List<CartModel>> cartItems,
    required List<CartModel> selectedItems,
    required this.onCheckoutComplete,
  })  : _cartItems = cartItems,
        _selectedItems = selectedItems;

  final Stream<List<CartModel>> _cartItems;
  final List<CartModel> _selectedItems;
  final VoidCallback onCheckoutComplete;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CartModel>>(
      stream: _cartItems,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final selectedItems = _selectedItems;
        double productCost = selectedItems.fold(
            0.0, (sum, item) => sum + item.productPrice * item.quantity);
        int totalQuantity =
            selectedItems.fold(0, (sum, item) => sum + item.quantity);

        double totalCost = productCost;

        return DraggableScrollableSheet(
          initialChildSize: 0.2,
          minChildSize: 0.05,
          maxChildSize: 0.3,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, -1),
                      blurRadius: 20.0)
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 20),
                        child: Container(
                          height: 6,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Product Quantity',
                            style: AppStyle.regular_14
                                .copyWith(color: AppColor.black),
                          ),
                          Text(totalQuantity.toString(),
                              style: AppStyle.regular_14
                                  .copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      spaceH8,
                      Divider(
                        color: Colors.grey[300],
                        thickness: 2.5,
                      ),
                      spaceH8,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Product price',
                            style: AppStyle.regular_14
                                .copyWith(color: AppColor.black),
                          ),
                          Text(totalCost.toVND(),
                              style: AppStyle.regular_14
                                  .copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      CrElevatedButton(
                        height: 60.0,
                        borderRadius: BorderRadius.circular(25.0),
                        text: 'Proceed to checkout',
                        onPressed: () {
                          if (selectedItems.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('No items selected for checkout')),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                      cartData: selectedItems,
                                      totalPrice: totalCost,
                                      totalProduct: totalQuantity,
                                    )),
                          ).then((result) {
                            if (result == true) {
                              // Only remove the selected items after a successful checkout
                              onCheckoutComplete();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
