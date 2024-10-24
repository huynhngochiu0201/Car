import 'package:app_car_rescue/constants/app_style.dart';
import 'package:flutter/material.dart';
import '../../constants/app_color.dart';

class CrTextField extends StatelessWidget {
  const CrTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.hintText,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.textInputAction,
    this.validator,
    this.readOnly = false,
    this.labelText,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? labelText;
  final Icon? prefixIcon;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 48.6,
        ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: textInputAction,
          validator: validator,
          readOnly: readOnly,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            filled: true,
            fillColor: AppColor.white,
            hintText: hintText,
            hintStyle: AppStyle.regular_14.copyWith(color: AppColor.black),
            labelText: labelText,
            prefixIcon: prefixIcon,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.D6D6D6),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.black.withOpacity(0.5)),
            ),
            errorStyle: const TextStyle(color: AppColor.red),
          ),
        ),
      ],
    );
  }
}
