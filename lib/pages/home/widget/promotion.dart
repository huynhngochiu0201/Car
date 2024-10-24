import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../gen/assets.gen.dart';

class Promotion extends StatelessWidget {
  const Promotion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Container(
      decoration: BoxDecoration(
          color: AppColor.F8F8FA,
          borderRadius: BorderRadius.circular(10.0)),
      height: 158.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.asset(
          Assets.images.vf3BannerJpg.path,
          fit: BoxFit.cover,
        ),
      )),
                );
  }
}