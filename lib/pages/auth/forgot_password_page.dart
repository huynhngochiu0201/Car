import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/pages/auth/login_page.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../components/button/cr_elevated_button.dart';
import '../../components/snack_bar/td_snack_bar.dart';
import '../../components/snack_bar/top_snack_bar.dart';
import '../../components/text_field/cr_text_field.dart';
import '../../utils/validator.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isLoading = false;

  final _auth = FirebaseAuth.instance;

  Future<void> _onSubmit(BuildContext context) async {
    if (formKey.currentState!.validate() == false) {
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    _auth
        .sendPasswordResetEmail(email: emailController.text.trim())
        .then((value) {
      showTopSnackBar(
        context,
        const TDSnackBar.success(
            message: 'Please check email to create password 😍'),
      );

      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginPage(email: emailController.text.trim()),
        ),
        (Route<dynamic> route) => false,
      );
    }).catchError((onError) {
      FirebaseAuthException a = onError as FirebaseAuthException;
      showTopSnackBar(
        context,
        TDSnackBar.error(message: a.message ?? ''),
      );
    }).whenComplete(() {
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 32.0).copyWith(top: 53.0),
          child: Form(
            key: formKey,
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
                  maxLines: 1,
                  controller: emailController,
                  hintText: 'enter your email here',
                  validator: Validator.email,
                  onFieldSubmitted: (_) => _onSubmit(context),
                  textInputAction: TextInputAction.done,
                ),
                spaceH20,
                CrElevatedButton.outline(
                  onPressed: () => _onSubmit(context),
                  text: 'Next',
                  isDisable: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
