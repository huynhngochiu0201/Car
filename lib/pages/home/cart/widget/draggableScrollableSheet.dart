import 'package:app_car_rescue/resources/double_extension.dart';
import 'package:flutter/material.dart';
import '../../../../components/button/cr_elevated_button.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_style.dart';
import '../../../../models/cart_model.dart';
import '../../../../services/remote/cart_service.dart';
import '../checkouts/checkouts_page.dart';

class DraggbleScrollable extends StatefulWidget {
  const DraggbleScrollable({
    super.key,
    required Stream<List<CartModel>> cartItems,
    required List<CartModel> selectedItems,
    required this.onCheckoutComplete,
    required this.cartService,
  })  : _cartItems = cartItems,
        _selectedItems = selectedItems;

  final Stream<List<CartModel>> _cartItems;
  final List<CartModel> _selectedItems;
  final VoidCallback onCheckoutComplete;
  final CartService cartService;

  @override
  DraggbleScrollableState createState() => DraggbleScrollableState();
}

class DraggbleScrollableState extends State<DraggbleScrollable> {
  bool _selectAll = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CartModel>>(
      stream: widget._cartItems,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final selectedItems = widget._selectedItems;
        double productCost = selectedItems.fold(
            0.0, (sum, item) => sum + item.productPrice * item.quantity);
        int totalQuantity =
            selectedItems.fold(0, (sum, item) => sum + item.quantity);

        double totalCost = productCost;

        return DraggableScrollableSheet(
          initialChildSize: 0.2,
          minChildSize: 0.03,
          maxChildSize: 0.25,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                      ),
                      child: Container(
                        height: 6,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _selectAll,
                          onChanged: (bool? value) async {
                            setState(() {
                              _selectAll = value ?? false;
                              widget._selectedItems.clear();
                            });

                            List<CartModel> cartItems = snapshot.data!;

                            if (_selectAll) {
                              // Chọn tất cả sản phẩm và tích checkbox của từng sản phẩm
                              for (var item in cartItems) {
                                item.isChecked =
                                    true; // Cập nhật trạng thái của từng item
                                widget._selectedItems
                                    .add(item); // Thêm vào danh sách đã chọn
                                try {
                                  await widget.cartService.updateCheckboxStatus(
                                      item.productId, true);
                                  print(
                                      'Checkbox status updated on Firebase (select all)');
                                } catch (e) {
                                  print(
                                      'Error updating checkbox status: ${e.toString()}');
                                }
                              }
                            } else {
                              // Bỏ chọn tất cả sản phẩm và bỏ tích checkbox của từng sản phẩm
                              for (var item in cartItems) {
                                item.isChecked =
                                    false; // Cập nhật trạng thái của từng item
                                try {
                                  await widget.cartService.updateCheckboxStatus(
                                      item.productId, false);
                                  print(
                                      'Checkbox status updated on Firebase (deselect all)');
                                } catch (e) {
                                  print(
                                      'Error updating checkbox status: ${e.toString()}');
                                }
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 2.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
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
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: CrElevatedButton(
                        height: 60.0,
                        borderRadius: BorderRadius.circular(25.0),
                        text: 'Proceed to checkout ($totalQuantity)',
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
                              // Chỉ xóa các sản phẩm đã chọn sau khi thanh toán thành công
                              widget.onCheckoutComplete();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
