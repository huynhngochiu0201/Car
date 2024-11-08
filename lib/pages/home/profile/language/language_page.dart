import 'package:app_car_rescue/components/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Language'),
    );
  }
}
