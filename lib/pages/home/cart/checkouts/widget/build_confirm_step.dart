import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            AppLocalizations.of(context)?.orderCompleted ?? 'Order Completed',
            style: AppStyle.bold_24,
          ),
        ),
        spaceH68,
        SvgPicture.asset(Assets.icons.doneOder),
        spaceH54,
        Text(AppLocalizations.of(context)?.thankYouForYourPurchase ??
            "Thank you for your purchase."),
        Text(AppLocalizations.of(context)?.youCanViewYourOrderInMyOrders ??
            " You can view your order in ‘My Orders Section’"),
      ],
    );
  }
}
