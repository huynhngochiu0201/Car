import 'package:flutter/material.dart';

import '../../../../../components/text_field/cr_text_field.dart';
import '../../../../../constants/app_style.dart';
import '../../../../../utils/spaces.dart';
import '../../../../../utils/validator.dart';

class BuildAddressStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  const BuildAddressStep(
      {super.key,
      required this.nameController,
      required this.emailController,
      required this.phoneController,
      required this.addressController});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'STEP 1',
              style: AppStyle.regular_12,
            ),
            Text(
              'Shipping',
              style: AppStyle.bold_24,
            ),
            spaceH20,
            CrTextField(
              controller: nameController,
              labelText: 'First name',
              validator: Validator.required,
              textInputAction: TextInputAction.next,
            ),
            spaceH30,
            CrTextField(
              controller: emailController,
              labelText: 'Email',
              validator: Validator.email,
              textInputAction: TextInputAction.next,
            ),
            spaceH30,
            CrTextField(
              controller: phoneController,
              labelText: 'Phone Number',
              validator: Validator.phoneNumber,
              textInputAction: TextInputAction.next,
            ),
            spaceH30,
            CrTextField(
              maxLines: 2,
              controller: addressController,
              labelText: 'Address',
              validator: Validator.required,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }
}
