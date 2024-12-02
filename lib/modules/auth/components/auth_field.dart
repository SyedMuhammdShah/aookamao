import 'package:flutter/material.dart';
import 'package:aookamao/user/data/constants/constants.dart';

class AuthField extends StatefulWidget {
  final String title;
  final String hintText;
  final Color? titleColor;
  final int? maxLength;
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool isEnable;
  final String? Function(String?)? validator;
  final int? maxLines;
  const AuthField({
    required this.title,
    required this.hintText,
    required this.controller,
    this.validator,
    this.titleColor,
    this.maxLines,
    this.textInputAction,
    this.keyboardType,
    this.isPassword = false,
    this.maxLength ,
  this.isEnable = true,
    super.key,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppTypography.kMedium16.copyWith(
            color: widget.titleColor ?? AppColors.kGrey70,
          ),
        ),
        SizedBox(height: AppSpacing.fiveVertical),
        TextFormField(
          enabled: widget.isEnable,
          maxLength: widget.maxLength,
          controller: widget.controller,
          validator: widget.validator,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          obscureText: widget.isPassword ? isObscure : false,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: Icon(
                      isObscure ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.kGrey100,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
