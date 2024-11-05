import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/app_color.dart';
import '../../gen/assets.gen.dart';

class CrSearchBox extends StatelessWidget {
  const CrSearchBox({super.key, this.controller, this.onChanged});

  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(width: 1.0, color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: AppColor.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: const TextStyle(color: AppColor.grey),
          prefixIcon: SvgPicture.asset(
            Assets.icons.seach,
            width: 18.0,
            height: 18.0,
            colorFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.srcIn,
            ),
            fit: BoxFit.scaleDown,
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 36.0),
        ),
      ),
    );
  }
}
