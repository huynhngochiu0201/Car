import 'package:app_car_rescue/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_color.dart';

class BottomNavBarCurvedFb1 extends StatefulWidget {
  const BottomNavBarCurvedFb1({
    super.key,
    required this.onPressed,
    required this.selected,
  });
  final Function(int) onPressed;
  final int selected;

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarCurvedFb1State createState() => _BottomNavBarCurvedFb1State();
}

class _BottomNavBarCurvedFb1State extends State<BottomNavBarCurvedFb1> {
  @override
  Widget build(BuildContext context) {
    double height = 56;
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavBarIcon(
              svg: Assets.icons.home,
              selected: widget.selected == 0,
              onPressed: () => widget.onPressed(0),
              defaultColor: AppColor.BEBFC4,
              selectedColor: AppColor.black,
            ),
            NavBarIcon(
              svg: Assets.icons.mapPinSvgrepoCom,
              selected: widget.selected == 1,
              onPressed: () => widget.onPressed(1),
              defaultColor: AppColor.BEBFC4,
              selectedColor: AppColor.black,
            ),
            NavBarIcon(
              svg: Assets.icons.shopCart,
              selected: widget.selected == 2,
              onPressed: () => widget.onPressed(2),
              defaultColor: AppColor.BEBFC4,
              selectedColor: AppColor.black,
            ),
            NavBarIcon(
              svg: Assets.icons.profile,
              selected: widget.selected == 3,
              onPressed: () => widget.onPressed(3),
              defaultColor: AppColor.BEBFC4,
              selectedColor: AppColor.black,
            ),
            NavBarIcon(
              svg: Assets.icons.notification,
              selected: widget.selected == 4,
              onPressed: () => widget.onPressed(4),
              defaultColor: AppColor.BEBFC4,
              selectedColor: AppColor.black,
            )
          ],
        ),
      ),
    );
  }
}

class NavBarIcon extends StatelessWidget {
  const NavBarIcon({
    super.key,
    required this.selected,
    required this.onPressed,
    this.selectedColor = AppColor.black,
    this.defaultColor = AppColor.BEBFC4,
    required this.svg,
  });

  final String svg;
  final bool selected;
  final Function() onPressed;
  final Color defaultColor;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svg,
            color: selected ? selectedColor : defaultColor,
            height: 25.0,
            width: 25.0,
          ),
        ],
      ),
    );
  }
}
