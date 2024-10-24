import 'dart:io';
import 'dart:developer' as dev;
import 'package:app_car_rescue/models/user_model.dart';
import 'package:app_car_rescue/pages/auth/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../components/button/cr_elevated_button.dart';
import '../../components/snack_bar/td_snack_bar.dart';
import '../../components/snack_bar/top_snack_bar.dart';
import '../../components/text_field/cr_text_field.dart';
import '../../components/text_field/cr_text_field_password.dart';
import '../../constants/app_color.dart';
import '../../constants/app_style.dart';
import '../../utils/spaces.dart';
import '../../utils/validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? fileAvatar;
  bool isLoading = false;

  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;

  // tao tham chieu den collection task luu tru trong firebase
  // de add, update, delete
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users'); // tham chieu

  Future<String?> uploadFile(File file) async {
    final now = DateTime.now();
    String path =
        DateTime(now.year, now.month, now.day, now.hour, now.minute).toString();

    final snapshot = await _storage.ref().child(path).putFile(file);

    try {
      return snapshot.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadAvatar() async {
    return fileAvatar != null ? await uploadFile(fileAvatar!) : null;
  }

  Future<void> pickAvatar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result == null) return;
    fileAvatar = File(result.files.single.path!);
    setState(() {});
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (formKey.currentState!.validate() == false) {
      return;
    }

    setState(() => isLoading = true);

    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text)
        .then((value) async {
      UserModel user = UserModel()
        ..name = nameController.text.trim()
        ..email = emailController.text.trim()
        ..avatar = fileAvatar != null ? await uploadAvatar() : null;

      _addUser(user);

      if (!context.mounted) return;

      showTopSnackBar(
        context,
        const TDSnackBar.success(
            message: 'Register successfully, please login 😍'),
      );

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

  void _addUser(UserModel user) {
    userCollection
        .doc(user.email)
        .set(user.toJson())
        .then((_) {})
        .catchError((error) {
      dev.log("Failed to add Task: $error");
    });
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
                  hintText: 'Enter your name',
                  textInputAction: TextInputAction.next,
                  validator: Validator.required,
                  controller: nameController,
                ),
                spaceH20,
                CrTextField(
                  hintText: 'Email address',
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  validator: Validator.email,
                ),
                spaceH20,
                CrTextFieldPassword(
                  hintText: 'Password',
                  controller: passwordController,
                  textInputAction: TextInputAction.next,
                  validator: Validator.password,
                ),
                spaceH20,
                CrTextFieldPassword(
                    controller: confirmPasswordController,
                    onChanged: (_) => setState(() {}),
                    hintText: 'Confirm Password',
                    onFieldSubmitted: (_) => _onSubmit(context),
                    textInputAction: TextInputAction.done,
                    validator: Validator.confirmPassword(
                      passwordController.text,
                    )),
                spaceH44,
                CrElevatedButton(
                  onPressed: () => _onSubmit(context),
                  text: 'Sign up',
                  isDisable: isLoading,
                  fontSize: 14,
                  width: 100.0,
                ),
                spaceH150,
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have account? , ',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Log in',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
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
