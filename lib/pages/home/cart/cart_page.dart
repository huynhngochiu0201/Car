import 'package:flutter/material.dart';
import 'package:app_car_rescue/models/cart_model.dart';
import 'package:app_car_rescue/services/remote/cart_service.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/components/app_bar/custom_app_bar.dart';
import 'package:app_car_rescue/components/snack_bar/td_snack_bar.dart';
import 'package:app_car_rescue/components/snack_bar/top_snack_bar.dart';
import 'package:app_car_rescue/resources/double_extension.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app_car_rescue/pages/home/cart/widget/ctdraggableScrollableSheet.dart';

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

  Future<void> _removeOnlySelectedItems() async {
    setState(() => _isLoading = true);
    try {
      for (var item in _selectedItems) {
        await _cartService.removeFromCart(item.productId);
      }
      showTopSnackBar(context,
          TDSnackBar.success(message: 'Checked items removed from cart'));
      _selectedItems.clear();
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

              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    return _buildCartItem(cartItem);
                  },
                ),
              );
            },
          ),
          CTDraggableScrollable(
            cartItems: _cartItemsStream,
            selectedItems: _selectedItems,
            onCheckoutComplete: _removeOnlySelectedItems,
            cartService: _cartService,
          ),
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
                    spaceH6,
                    _buildQuantityControl(cartItem),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
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
          onTap: () => _showRemoveDialog(cartItem),
          child: const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.delete, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  void _showRemoveDialog(CartModel cartItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.confirm ?? 'Confirm'),
        content: Text(
            AppLocalizations.of(context)?.areYouSureYouWantToRemoveThisItemFromTheCart ??
                'Are you sure you want to remove this item from the cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              _removeItem(cartItem.productId);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)?.remove ?? 'Remove'),
          ),
        ],
      ),
    );
  }
}
