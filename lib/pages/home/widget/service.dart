import 'package:app_car_rescue/utils/spaces.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_color.dart';
import '../../../gen/assets.gen.dart';

class Service extends StatelessWidget {
  const Service({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: AppColor.F8F8FA,
                  borderRadius: BorderRadius.circular(10.0)),
              height: 154.0,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  Assets.images.vf3BannerJpg.path,
                  fit: BoxFit.cover,
                ),
              )),
          spaceH10,
        ],
      ),
    );
  }
}
