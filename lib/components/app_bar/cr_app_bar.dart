import 'package:app_car_rescue/gen/assets.gen.dart';
import 'package:app_car_rescue/pages/home/cart/cart_page.dart';
import 'package:app_car_rescue/pages/home/profile/notification/notification_page.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_color.dart';
import '../../pages/home/search/search_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CrAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CrAppBar({
    super.key,
    this.leftPressed,
    this.rightPressed,
    this.title,
    this.avatar,
    this.color = AppColor.white,
    this.menuIconPath,
    this.hasNotification = false, // Thêm thuộc tính này
  });

  final VoidCallback? leftPressed;
  final VoidCallback? rightPressed;
  final String? title;
  final String? avatar;
  final Color color;
  final String? menuIconPath;
  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 32.0).copyWith(
          top: MediaQuery.of(context).padding.top + 18.0, bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor.E43484B),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Row(
                  children: [
                    spaceW10,
                    SvgPicture.asset(
                      Assets.icons.seach,
                      color: AppColor.black,
                      height: 18.0,
                      width: 18.0,
                    ),
                    spaceW10,
                    Text(AppLocalizations.of(context)?.search ?? 'Search...'),
                  ],
                ),
              ),
            ),
          ),
          spaceW24,
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                },
                child: const Icon(Icons.shopping_cart),
              ),
              spaceW10,
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                },
                child: Stack(
                  clipBehavior:
                      Clip.none, // Để cho chấm đỏ có thể đè lên ngoài Stack
                  children: [
                    SvgPicture.asset(
                      Assets.icons.notification,
                      color: AppColor.black,
                      height: 20.0,
                      width: 20.0,
                    ),
                    //if (hasNotification) // Nếu có thông báo, hiển thị chấm đỏ
                    Positioned(
                      right: -0.1, // Vị trí chấm đỏ
                      top: -0.1,
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(86.0);
}
