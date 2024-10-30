import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/gen/assets.gen.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../constants/app_style.dart';

class BuildDetailsStep extends StatefulWidget {
  const BuildDetailsStep({super.key});

  @override
  _BuildDetailsStepState createState() => _BuildDetailsStepState();
}

class _BuildDetailsStepState extends State<BuildDetailsStep> {
  int selectedPaymentIndex = -1; // Track the selected payment option

  void _onPaymentOptionTap(int index) {
    setState(() {
      selectedPaymentIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STEP 2',
            style: AppStyle.regular_12,
          ),
          Text(
            'Payment',
            style: AppStyle.bold_24,
          ),
          spaceH36,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPaymentOption(0, Assets.icons.money, 'Cash'),
              _buildPaymentOption(1, Assets.icons.bag, 'Card'),
              _buildPaymentOption(2, Assets.icons.dot, 'Wallet'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(int index, String iconPath, String label) {
    bool isSelected =
        selectedPaymentIndex == index; // Check if this option is selected
    return InkWell(
      onTap: () => _onPaymentOptionTap(index), // Handle tap
      splashColor:
          AppColor.primary.withOpacity(0.2), // Color of the ripple effect
      highlightColor:
          AppColor.primary.withOpacity(0.1), // Color of the highlight effect
      borderRadius: BorderRadius.circular(
          10.0), // Ensure the ripple is contained within the rounded edges
      child: Container(
        height: 64.0,
        width: 94.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: isSelected
              ? AppColor.grey500
              : AppColor.white, // Change color based on selection
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.blue.withOpacity(0.4)
                  : Colors.grey.withOpacity(
                      0.5), // Adjust shadow color based on selection
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 12),
          child: Column(
            children: [
              Center(
                child: SvgPicture.asset(iconPath),
              ),
              Text(label)
            ],
          ),
        ),
      ),
    );
  }
}
