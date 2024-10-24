import 'package:flutter/material.dart';
import '../../constants/app_color.dart';
import '../../constants/app_style.dart';

class CrTextFieldPassword extends StatefulWidget {
  const CrTextFieldPassword({
    super.key,
    this.controller,
    this.onChanged,
    this.focusNode,
    this.keyboardType,
    this.hintText,
    this.onFieldSubmitted,
    this.textInputAction,
    this.validator,
  });

  final TextEditingController? controller;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String? hintText;
  // final Icon? prefixIcon;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  // final bool readOnly;

  @override
  State<CrTextFieldPassword> createState() => _CrTextFieldPasswordState();
}

class _CrTextFieldPasswordState extends State<CrTextFieldPassword> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 48.6,
        ),
        TextFormField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          obscureText: !showPassword,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          onFieldSubmitted: widget.onFieldSubmitted,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.white,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.D6D6D6),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.black.withOpacity(0.5)),
            ),
            hintText: widget.hintText,
            hintStyle: AppStyle.regular_14.copyWith(color: AppColor.black),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => showPassword = !showPassword),
              child: showPassword
                  ? Icon(Icons.remove_red_eye_rounded,
                      color: AppColor.brown.withOpacity(0.68))
                  : Icon(Icons.remove_red_eye_outlined, color: AppColor.grey),
            ),
            errorStyle: const TextStyle(color: AppColor.red),
          ),
        ),
      ],
    );
  }
}
