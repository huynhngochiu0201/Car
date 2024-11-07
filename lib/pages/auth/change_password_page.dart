import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/button/cr_elevated_button.dart';
import '../../components/snack_bar/td_snack_bar.dart';
import '../../components/snack_bar/top_snack_bar.dart';
import '../../components/text_field/cr_text_field_password.dart';
import '../../constants/app_color.dart';
import '../../gen/assets.gen.dart';
import '../../services/shared_prefs.dart';
import '../../utils/validator.dart';
import 'login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final _auth = FirebaseAuth.instance;

  Future<void> _changePassword(BuildContext context) async {
    if (formKey.currentState?.validate() == false) return;
    setState(() => isLoading = true);
    try {
      final user = _auth.currentUser;

      final credential = EmailAuthProvider.credential(
        email: SharedPrefs.user?.email ?? '',
        password: currentPasswordController.text,
      );
      await user?.reauthenticateWithCredential(credential);
      await user?.updatePassword(newPasswordController.text);

      if (!context.mounted) return;
      showTopSnackBar(
        context,
        const TDSnackBar.success(
            message: 'Password has been changed, please login 😍'),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginPage(email: SharedPrefs.user?.email ?? ''),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      setState(() => isLoading = false);
      showTopSnackBar(
        context,
        const TDSnackBar.error(message: 'Current password is wrong😐'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(
                top: MediaQuery.of(context).padding.top + 38.0, bottom: 16.0),
            children: [
              const Center(
                child: Text('Change Password',
                    style: TextStyle(color: AppColor.red, fontSize: 24.0)),
              ),
              const SizedBox(height: 38.0),
              Center(
                child: Image.asset(Assets.images.autocarlogo.path,
                    width: 90.0, fit: BoxFit.cover),
              ),
              const SizedBox(height: 46.0),
              CrTextFieldPassword(
                controller: currentPasswordController,
                hintText: 'Current Password',
                validator: Validator.required,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 18.0),
              CrTextFieldPassword(
                controller: newPasswordController,
                hintText: 'New Password',
                validator: Validator.password,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 18.0),
              CrTextFieldPassword(
                controller: confirmPasswordController,
                onChanged: (_) => setState(() {}),
                hintText: 'Confirm Password',
                validator:
                    Validator.confirmPassword(newPasswordController.text),
                onFieldSubmitted: (_) => _changePassword(context),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 92.0),
              CrElevatedButton.outline(
                onPressed: () => _changePassword(context),
                text: 'Done',
                isDisable: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
