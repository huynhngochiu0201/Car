import 'package:app_car_rescue/resources/double_extension.dart';
import 'package:flutter/material.dart';
import '../../../../components/button/cr_elevated_button.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/app_style.dart';
import '../../../../models/cart_model.dart';
import '../../../../services/remote/cart_service.dart';
import '../checkouts/checkouts_page.dart';

class CTDraggableScrollable extends StatefulWidget {
  const CTDraggableScrollable({
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
  CTDraggableScrollableState createState() => CTDraggableScrollableState();
}

class CTDraggableScrollableState extends State<CTDraggableScrollable> {
  bool _selectAll = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CartModel>>(
      stream: widget._cartItems,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final cartItems = snapshot.data!;
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
                    _buildDraggableHandle(),
                    _buildSelectAllCheckbox(cartItems),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 2.5,
                    ),
                    _buildTotalPriceRow(totalCost),
                    const SizedBox(height: 20.0),
                    _buildCheckoutButton(totalQuantity, totalCost),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Widget for the draggable handle at the top
  Widget _buildDraggableHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        height: 6,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Widget for the select all checkbox
  Widget _buildSelectAllCheckbox(List<CartModel> cartItems) {
    return Row(
      children: [
        Checkbox(
          value: _selectAll,
          onChanged: (bool? value) async {
            setState(() {
              _selectAll = value ?? false;
            });
            await _toggleSelectAll(cartItems);
          },
        ),
        Text(
          'Select All',
          style: AppStyle.regular_14.copyWith(color: AppColor.black),
        ),
      ],
    );
  }

  // Toggle select all or deselect all items in the cart
  Future<void> _toggleSelectAll(List<CartModel> cartItems) async {
    widget._selectedItems.clear();

    for (var item in cartItems) {
      item.isChecked = _selectAll;
      if (_selectAll) {
        widget._selectedItems.add(item);
      }

      try {
        await widget.cartService
            .updateCheckboxStatus(item.productId, _selectAll);
      } catch (e) {
        print('Error updating checkbox status: ${e.toString()}');
      }
    }
    setState(() {});
  }

  // Widget for total price row
  Widget _buildTotalPriceRow(double totalCost) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Product price',
            style: AppStyle.regular_14.copyWith(color: AppColor.black),
          ),
          Text(totalCost.toVND(),
              style: AppStyle.regular_14.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Widget for the checkout button
  Widget _buildCheckoutButton(int totalQuantity, double totalCost) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: CrElevatedButton(
        height: 60.0,
        borderRadius: BorderRadius.circular(25.0),
        text: 'Proceed to checkout ( $totalQuantity )',
        onPressed: () {
          if (widget._selectedItems.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No items selected for checkout')),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutPage(
                cartData: widget._selectedItems,
                totalPrice: totalCost,
                totalProduct: totalQuantity,
              ),
            ),
          ).then((result) {
            if (result == true) {
              widget.onCheckoutComplete();
            }
          });
        },
      ),
    );
  }
}
