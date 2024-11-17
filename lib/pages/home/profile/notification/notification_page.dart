import 'package:app_car_rescue/components/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../../constants/app_color.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: 'Notification'),
    );
  }
}
