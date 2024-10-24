import 'dart:async';
import 'package:flutter/material.dart';
import '../../constants/app_color.dart';
import '../../gen/assets.gen.dart';
import '../../services/shared_prefs.dart';
import '../auth/login_page.dart';

import '../main_page.dart';
import '../onboarding/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  void _checkToken() {
    Timer(const Duration(milliseconds: 2000), () {
      if (SharedPrefs.isAccessed) {
        if (SharedPrefs.isLogin) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainPage(title: '',),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const OnboardingPage(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Assets.images.autocarlogo.path,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
