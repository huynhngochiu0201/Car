import 'package:app_car_rescue/gen/assets.gen.dart';
import 'package:app_car_rescue/pages/home/cart/checkouts/widget/build_address_step.dart';
import 'package:app_car_rescue/pages/home/cart/checkouts/widget/build_details_step.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../components/app_bar/custom_app_bar.dart';
import '../../../../components/button/cr_elevated_button.dart';
import '../../../../components/snack_bar/td_snack_bar.dart';
import '../../../../components/snack_bar/top_snack_bar.dart';
import '../../../../models/add_checkout_model.dart';
import '../../../../models/cart_model.dart';
import '../../../../services/remote/cart_service.dart';
import '../../../../services/remote/checkout_service.dart';
import 'widget/build_confirm_step.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartModel> cartData;
  final double totalPrice;
  final int totalProduct;

  const CheckoutPage({
    super.key,
    required this.cartData,
    required this.totalPrice,
    required this.totalProduct,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final CheckoutService _checkoutService = CheckoutService();
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _nextStep() {
    // Chỉ cho phép sang bước tiếp theo nếu tất cả các trường bắt buộc đã được điền ở bước 1
    if (_currentStep == 0) {
      if (_emailController.text.trim().isEmpty ||
          _nameController.text.trim().isEmpty ||
          _phoneController.text.trim().isEmpty ||
          _addressController.text.trim().isEmpty) {
        showTopSnackBar(
          context,
          const TDSnackBar.error(message: 'Vui lòng điền đầy đủ thông tin'),
        );
        return;
      }
    }

    setState(() {
      _currentStep = (_currentStep + 1) % 3;
    });
  }

  void _handleCheckout() async {
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (email.isEmpty ||
        name.isEmpty ||
        phoneNumber.isEmpty ||
        address.isEmpty) {
      showTopSnackBar(
        context,
        const TDSnackBar.error(message: 'Please fill all the fields'),
      );
      return;
    }

    // Prepare checkout model
    final checkoutModel = AddCheckoutModel(
      userId: _checkoutService.userId,
      cartData: widget.cartData,
      totalPrice: widget.totalPrice,
      totalProduct: widget.totalProduct,
      email: email,
      name: name,
      phoneNumber: phoneNumber,
      address: address,
      createdAt: DateTime.now(),
    );

    // Place order
    String response = await _checkoutService.placeOrder(checkoutModel);

    // Show feedback
    showTopSnackBar(
      context,
      TDSnackBar.success(message: response),
    );

    // If the order is placed successfully, clear the selected items from the cart and navigate back
    if (response == 'Order placed successfully') {
      // Chỉ xóa các mục được chọn sau khi thanh toán thành công
      await _clearSelectedItemsFromCart();
      Navigator.pop(
          context, true); // Return true to indicate a successful checkout
    }
  }

  // Hàm để xóa các mục được chọn trong giỏ hàng
  Future<void> _clearSelectedItemsFromCart() async {
    final CartService cartService = CartService();
    for (var item in widget.cartData) {
      await cartService.removeFromCart(item.productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: 'Checkout'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23.0)
              .copyWith(bottom: 20.0),
          child: Column(
            children: [
              EasyStepper(
                activeStepBackgroundColor: Colors.transparent,
                finishedStepBackgroundColor: Colors.transparent,
                activeStep: _currentStep,
                steps: [
                  EasyStep(
                    customStep: SvgPicture.asset(Assets.icons.address),
                  ),
                  EasyStep(
                    customStep: SvgPicture.asset(Assets.icons.bag),
                  ),
                  EasyStep(
                    customStep: SvgPicture.asset(Assets.icons.check),
                  ),
                ],
                onStepReached: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
              ),
              Expanded(
                child: _buildStepContent(),
              ),
              CrElevatedButton(
                onPressed: _currentStep == 2 ? _handleCheckout : _nextStep,
                height: 60.0,
                borderRadius: BorderRadius.circular(25.0),
                text: (_currentStep == 2 ? 'Place Order' : 'Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return BuildAddressStep(
          nameController: _nameController,
          emailController: _emailController,
          phoneController: _phoneController,
          addressController: _addressController,
        );
      case 1:
        return BuildDetailsStep(
            // cartData: widget.cartData,
            // totalPrice: widget.totalPrice,
            // totalProduct: widget.totalProduct,
            );
      case 2:
        return BuildConfirmStep(
            // cartData: widget.cartData,
            // totalPrice: widget.totalPrice,
            // totalProduct: widget.totalProduct,
            );
      default:
        return const Text('Error');
    }
  }
}
