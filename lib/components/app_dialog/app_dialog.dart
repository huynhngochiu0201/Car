import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../button/cr_elevated_button.dart';

class AppDialog {
  AppDialog._();

  static void dialog(
    BuildContext context, {
    required title,
    required content,
    Function()? action,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(
          content,
          style: const TextStyle(color: AppColor.brown, fontSize: 18.0),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CrElevatedButton.smallOutline(
                onPressed: () => Navigator.pop(context),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                text: 'No',
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: CrElevatedButton.smallOutline(
                  onPressed: () {
                    action?.call();
                    Navigator.pop(context);
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  text: 'Yes',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
