import 'package:app_car_rescue/gen/assets.gen.dart';
import 'package:app_car_rescue/pages/home/cart/cart_page.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_color.dart';
import '../../pages/home/search/search_page.dart';

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
            child: SvgPicture.asset(Assets.icons.menuIcon),
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
              spaceW10,
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                  child: SvgPicture.asset(
                    Assets.icons.seach,
                    color: AppColor.black,
                    height: 20.0,
                    width: 20.0,
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
