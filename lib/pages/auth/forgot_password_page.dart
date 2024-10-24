import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/pages/auth/login_page.dart';
import 'package:app_car_rescue/utils/spaces.dart';

import 'package:flutter/material.dart';

import '../../components/text_field/cr_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 32.0).copyWith(top: 53.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: AppColor.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              // spreadRadius: 1,
                              //  blurRadius: 1,
                              offset: const Offset(0, 0.5),
                            ),
                          ],
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor.white)),
                      child: Icon(Icons.arrow_back)),
                ),
              ),
              spaceH32,
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Forgot password?',
                    style: AppStyle.bold_24,
                  )),
              spaceH18,
              Text(
                "Enter email associated with your account and we'll send and email with intructions to reset your password",
                style: AppStyle.regular_14.copyWith(color: AppColor.black),
              ),
              spaceH54,
              CrTextField(
                prefixIcon: Icon(
                  Icons.email,
                  color: AppColor.grey300,
                ),
                hintText: 'enter your email here',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
