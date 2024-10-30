import 'dart:math' as math;
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/gen/assets.gen.dart';
import 'package:app_car_rescue/pages/home/cart/cart_page.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_color.dart';

class CrAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CrAppBar({
    super.key,
    this.leftPressed,
    this.rightPressed,
    this.title,
    this.avatar,
    this.color = AppColor.white,
    this.menuIconPath, // Add the menu icon SVG path as a new property
  });

  final VoidCallback? leftPressed;
  final VoidCallback? rightPressed;
  final String? title;
  final String? avatar;
  final Color color;
  final String? menuIconPath; // This will be the SVG path for the menu icon

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 32.0).copyWith(
          top: MediaQuery.of(context).padding.top + 18.0, bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: leftPressed,
            child: Transform.rotate(
              angle: 45 * math.pi / 180,
              child: Transform.rotate(
                  angle: -45 * math.pi / 180,
                  child: SvgPicture.asset(Assets.icons.menuIcon)),
            ),
          ),
          Text(
            'CarRescue',
            style: AppStyle.bold_20,
          ),
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );
                  },
                  child: Icon(Icons.shopping_cart)),
              spaceW14,
              GestureDetector(
                  child: SvgPicture.asset(
                Assets.icons.notification,
              )),
            ],
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(86.0);
}
