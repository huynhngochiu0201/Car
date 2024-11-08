import 'package:app_car_rescue/components/button/cr_elevated_button.dart';
import 'package:app_car_rescue/components/text_field/cr_text_field.dart';
import 'package:app_car_rescue/components/text_field/cr_text_field_password.dart';
import 'package:app_car_rescue/constants/app_color.dart';
import 'package:app_car_rescue/constants/app_style.dart';
import 'package:app_car_rescue/pages/auth/forgot_password_page.dart';
import 'package:app_car_rescue/pages/auth/register_page.dart';
import 'package:app_car_rescue/utils/spaces.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../components/snack_bar/td_snack_bar.dart';
import '../../components/snack_bar/top_snack_bar.dart';
import '../../models/user_model.dart';
import '../../services/shared_prefs.dart';
import '../../utils/validator.dart';
import '../main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.email});
  final String? email;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final _auth = FirebaseAuth.instance;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email ?? '';
  }

  Future<void> _submitLogin(BuildContext context) async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    setState(() => isLoading = true);
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text)
        .then((value) {
      _getUser();
    }).catchError((onError) {
      setState(() => isLoading = false);
      showTopSnackBar(
        context,
        const TDSnackBar.error(message: 'Email or Password is wrong😐'),
      );
    });
  }

  void _getUser() {
    userCollection
        .doc(emailController.text)
        .get()
        .then((snapshot) {
          final data = snapshot.data() as Map<String, dynamic>;
          SharedPrefs.user = UserModel.fromJson(data);
          if (!context.mounted) return;
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const MainPage(
                title: '',
              ),
            ),
            (route) => false,
          );
        })
        .catchError((onError) {})
        .whenComplete(
          () {
            setState(() => isLoading = false);
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 33.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 93.0),
                  child: SizedBox(
                      height: 96,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Log into \n your account',
                          style: AppStyle.bold_24,
                        ),
                      )),
                ),
                spaceH48,
                CrTextField(
                  maxLines: 1,
                  controller: emailController,
                  hintText: 'Email address',
                  validator: Validator.email,
                  textInputAction: TextInputAction.next,
                ),
                spaceH20,
                CrTextFieldPassword(
                  controller: passwordController,
                  hintText: 'Password',
                  onFieldSubmitted: (_) => _submitLogin(context),
                  textInputAction: TextInputAction.done,
                ),
                spaceH28,
                GestureDetector(
                  onTap: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage(),
                    ),
                    (Route<dynamic> route) => false,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Forgot Password?',
                      style:
                          AppStyle.regular_12.copyWith(color: AppColor.black),
                    ),
                  ),
                ),
                spaceH25,
                CrElevatedButton(
                  onPressed: () => _submitLogin(context),
                  text: 'Log In',
                  isDisable: isLoading,
                ),
                SizedBox(height: 230),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account?  ',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign Up',
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                  (Route<dynamic> route) => false,
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
