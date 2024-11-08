import 'dart:io';
import 'dart:developer' as dev;
import 'package:app_car_rescue/components/app_bar/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../../components/button/cr_elevated_button.dart';
import '../../../components/snack_bar/td_snack_bar.dart';
import '../../../components/snack_bar/top_snack_bar.dart';
import '../../../components/text_field/cr_text_field.dart';
import '../../../constants/app_color.dart';
import '../../../gen/assets.gen.dart';
import '../../../models/user_model.dart';
import '../../../services/shared_prefs.dart';
import '../../../utils/validator.dart';
import '../../main_page.dart';

class ChangeProfile extends StatefulWidget {
  const ChangeProfile({
    super.key,
  });

  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? fileAvatar;
  bool isLoading = false;
  UserModel user = SharedPrefs.user ?? UserModel();

  final _storage = FirebaseStorage.instance;

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
      type: FileType.media,
    );
    if (result == null) return;
    fileAvatar = File(result.files.single.path!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    nameController.text = user.name ?? '';
    emailController.text = user.email ?? '';
    // setState(() {});
  }

  Future<void> _updateProfile(BuildContext context) async {
    if (formKey.currentState!.validate() == false) {
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));

    final avatarUrl = await uploadAvatar();

    final body = UserModel()
      ..name = nameController.text.trim()
      ..email = emailController.text.trim()
      ..avatar = fileAvatar != null ? avatarUrl : null;

    userCollection.doc(user.email).update(body.toJson()).then((_) {
      SharedPrefs.user = body;

      if (!context.mounted) return;

      showTopSnackBar(
        context,
        const TDSnackBar.success(message: 'Profile has been saved 😍'),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MainPage(title: ''),
        ),
        (Route<dynamic> route) => false,
      );
    }).catchError((error) {
      dev.log("Failed to update Task: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'My Profile'),
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0)
                .copyWith(top: MediaQuery.of(context).padding.bottom + 10.0),
            children: [
              Center(
                child: _buildAvatar(),
              ),
              const SizedBox(height: 42.0),
              CrTextField(
                controller: nameController,
                hintText: "Full Name",
                prefixIcon: const Icon(Icons.person, color: AppColor.black),
                validator: Validator.required,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 18.0),
              CrTextField(
                controller: emailController,
                hintText: "Email",
                readOnly: true,
                prefixIcon: const Icon(Icons.email, color: AppColor.black),
              ),
              const SizedBox(height: 72.0),
              CrElevatedButton(
                onPressed: () => _updateProfile(context),
                text: 'Save',
                isDisable: isLoading,
              ),
              const SizedBox(height: 20.0),
              CrElevatedButton.outline(
                onPressed: () => Navigator.pop(context),
                text: 'Back',
                isDisable: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    const radius = 34.0;
    return GestureDetector(
      onTap: isLoading ? null : pickAvatar,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: isLoading
                ? CircleAvatar(
                    radius: radius,
                    backgroundColor: Colors.orange.shade200,
                    child: const SizedBox.square(
                      dimension: 32.0,
                      child: CircularProgressIndicator(
                        color: AppColor.pink,
                        strokeWidth: 2.0,
                      ),
                    ),
                  )
                : fileAvatar != null
                    ? CircleAvatar(
                        radius: radius,
                        backgroundImage:
                            FileImage(File(fileAvatar?.path ?? '')),
                      )
                    : user.avatar != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(radius),
                            child: Image.network(
                              user.avatar!,
                              fit: BoxFit.cover,
                              width: radius * 2,
                              height: radius * 2,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: radius * 2,
                                  height: radius * 2,
                                  color: AppColor.orange,
                                  child: const Center(
                                    child: Icon(Icons.error_rounded,
                                        color: AppColor.white),
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return const SizedBox.square(
                                  dimension: radius * 2,
                                  child: Center(
                                    child: SizedBox.square(
                                      dimension: 26.0,
                                      child: CircularProgressIndicator(
                                        color: AppColor.pink,
                                        strokeWidth: 2.0,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : CircleAvatar(
                            radius: radius,
                            backgroundImage:
                                // Assets.images.defaultAvatar.provider()
                                AssetImage(Assets.images.dummyCategory.path),
                          ),
          ),
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black)),
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 14.6,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
