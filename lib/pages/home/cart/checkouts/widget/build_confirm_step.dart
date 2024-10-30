import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../constants/app_style.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../utils/spaces.dart';

class BuildConfirmStep extends StatelessWidget {
  const BuildConfirmStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Order Completed',
            style: AppStyle.bold_24,
          ),
        ),
        spaceH68,
        SvgPicture.asset(Assets.icons.doneOder),
        spaceH54,
        Text("Thank you for your purchase."),
        Text(" You can view your order in ‘My Orders’"),
        Text("section.")
      ],
    );
  }
}
