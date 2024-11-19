import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_color.dart';
import '../../gen/assets.gen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SeachAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SeachAppBar(
      {super.key,
      this.leftPressed,
      this.rightPressed,
      this.avatar,
      this.color = AppColor.white,
      this.controller,
      this.onChanged});

  final VoidCallback? leftPressed;
  final VoidCallback? rightPressed;
  final String? avatar;
  final Color color;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 12.0).copyWith(
          top: MediaQuery.of(context).padding.top + 6.0, bottom: 10.0),
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: const Icon(Icons.arrow_back,
                    size: 30.0, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
              child: Container(
            height: 40.0,
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
                hintText: '${AppLocalizations.of(context)?.search}...',
                hintStyle: const TextStyle(color: AppColor.E43484B),
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
          ))
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(86.0);
}
