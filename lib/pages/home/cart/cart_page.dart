import 'package:app_car_rescue/resources/double_extension.dart';
import 'package:flutter/material.dart';
import 'package:app_car_rescue/components/app_bar/custom_app_bar.dart';
import 'package:app_car_rescue/components/snack_bar/td_snack_bar.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/components/button/cr_elevated_button.dart';
import 'package:app_car_rescue/models/cart_model.dart';
import 'package:app_car_rescue/services/remote/cart_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../components/snack_bar/top_snack_bar.dart';
import 'checkouts/checkouts_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  late Stream<List<CartModel>> _cartItemsStream;
  final List<CartModel> _selectedItems = [];
  bool _isLoading = false;
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _cartItemsStream = _cartService.getCartStream();
  }

  Future<void> _removeItem(String productId) async {
    setState(() => _isLoading = true);
    try {
      String res = await _cartService.removeFromCart(productId);
      showTopSnackBar(context, TDSnackBar.success(message: res));
      _selectedItems.removeWhere((item) => item.productId == productId);
    } catch (e) {
      showTopSnackBar(
          context, TDSnackBar.error(message: 'Error: ${e.toString()}'));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateQuantity(CartModel cartItem, int newQuantity) async {
    if (newQuantity < 1) return;
    setState(() => _isLoading = true);
    try {
      await _cartService.updateQuantity(cartItem.productId, newQuantity);
    } catch (e) {
      showTopSnackBar(
          context, TDSnackBar.error(message: 'Error: ${e.toString()}'));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleSelectAll(List<CartModel> cartItems) async {
    _selectedItems.clear();

    for (var item in cartItems) {
      item.isChecked = _selectAll;
      if (_selectAll) {
        _selectedItems.add(item);
      }
      try {
        await _cartService.updateCheckboxStatus(item.productId, _selectAll);
      } catch (e) {
        print('Error updating checkbox status: ${e.toString()}');
      }
    }
    setState(() {});
  }

  void _toggleSelection(CartModel cartItem, bool? isSelected) async {
    setState(() {
      cartItem.isChecked = isSelected ?? false;
      if (cartItem.isChecked) {
        if (!_selectedItems
            .any((item) => item.productId == cartItem.productId)) {
          _selectedItems.add(cartItem);
        }
      } else {
        _selectedItems
            .removeWhere((item) => item.productId == cartItem.productId);
      }
    });

    try {
      await _cartService.updateCheckboxStatus(
          cartItem.productId, cartItem.isChecked);
    } catch (e) {
      showTopSnackBar(
          context,
          TDSnackBar.error(
              message: 'Failed to update checkbox status: ${e.toString()}'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: AppLocalizations.of(context)?.yourCart ?? 'Your Cart'),
      backgroundColor: AppColor.white,
      body: Stack(
        children: [
          StreamBuilder<List<CartModel>>(
            stream: _cartItemsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                        '${AppLocalizations.of(context)?.error ?? 'Error'}: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                    child: Text(AppLocalizations.of(context)?.yourCartIsEmpty ??
                        'Your cart is empty'));
              }

              final cartItems = snapshot.data!;

              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  return _buildCartItem(cartItem);
                },
              );
            },
          ),
          _buildDraggableSheet(),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartModel cartItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Container(
        height: 115.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 2), blurRadius: 20.0),
          ],
        ),
        child: Row(
          children: [
            _buildImage(cartItem),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(cartItem),
                    Text(cartItem.productPrice.toVND(),
                        style: AppStyle.bold_16),
                    const Spacer(),
                    _buildQuantityControl(cartItem),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableSheet() {
    return StreamBuilder<List<CartModel>>(
      stream: _cartItemsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final cartItems = snapshot.data!;
        double productCost = _selectedItems.fold(
            0.0, (sum, item) => sum + item.productPrice * item.quantity);
        int totalQuantity =
            _selectedItems.fold(0, (sum, item) => sum + item.quantity);

        return DraggableScrollableSheet(
          expand: true,
          snap: true,
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
                    _buildTotalPriceRow(productCost),
                    const SizedBox(height: 20.0),
                    _buildCheckoutButton(totalQuantity, productCost),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

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
          AppLocalizations.of(context)?.selectAll ?? 'Select All',
          style: AppStyle.regular_14.copyWith(color: AppColor.black),
        ),
      ],
    );
  }

  Widget _buildTotalPriceRow(double totalCost) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)?.productPrice ?? 'Product price',
            style: AppStyle.regular_14.copyWith(color: AppColor.black),
          ),
          Text(totalCost.toVND(),
              style: AppStyle.regular_14.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(int totalQuantity, double totalCost) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: CrElevatedButton(
        height: 60.0,
        borderRadius: BorderRadius.circular(25.0),
        text:
            '${AppLocalizations.of(context)?.proceedToCheckout ?? 'Proceed to checkout'} ( $totalQuantity )',
        onPressed: () {
          if (_selectedItems.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)?.noItemsSelected ??
                      'No items selected for checkout')),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutPage(
                cartData: _selectedItems,
                totalPrice: totalCost,
                totalProduct: totalQuantity,
              ),
            ),
          ).then((result) {
            if (result == true) {
              setState(() {
                _selectedItems.clear();
              });
            }
          });
        },
      ),
    );
  }

  Widget _buildImage(CartModel cartItem) {
    return Container(
      width: 115.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10.0),
        ),
        color: AppColor.white,
        image: DecorationImage(
          image: NetworkImage(cartItem.productImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitle(CartModel cartItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 150.0,
          child: Text(
            cartItem.productName,
            style: AppStyle.bold_14,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        Checkbox(
          value: cartItem.isChecked,
          onChanged: (value) => _toggleSelection(cartItem, value),
        ),
      ],
    );
  }

  Widget _buildQuantityControl(CartModel cartItem) {
    return Row(
      children: [
        Container(
          height: 28.0,
          width: 80.0,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (cartItem.quantity > 1) {
                    _updateQuantity(cartItem, cartItem.quantity - 1);
                  }
                },
                child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 12.0,
                    child: Center(
                        child: Icon(
                            size: 20.0, Icons.remove, color: Colors.grey))),
              ),
              Text(
                cartItem.quantity.toString(),
                style: AppStyle.bold_12.copyWith(color: Colors.grey),
              ),
              GestureDetector(
                onTap: () => _updateQuantity(cartItem, cartItem.quantity + 1),
                child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 12.0,
                    child: Center(
                        child: const Icon(Icons.add,
                            size: 20.0, color: Colors.grey))),
              ),
            ],
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => _removeItem(cartItem.productId),
          child: const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.delete, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
