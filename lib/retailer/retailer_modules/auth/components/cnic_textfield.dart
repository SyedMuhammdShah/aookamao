import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/data/constants/app_colors.dart';
import '../../../../app/data/constants/app_spacing.dart';
import '../../../../app/data/constants/app_typography.dart';

class CNICTextField extends StatefulWidget {
  @override
  State<CNICTextField> createState() => _CNICTextFieldState();
  final String title;
 final TextEditingController controller;
  final String? Function(String?)? validator;

  const CNICTextField({super.key, required this.title, required this.controller, this.validator});
}

class _CNICTextFieldState extends State<CNICTextField> {

  String? _validateCNIC(String? value) {
    // Check if the value is empty
    if (value == null || value.isEmpty) {
      return 'CNIC number is required';
    }

    // Check if the CNIC matches the pattern "#####-#######-#"
    final cnicPattern = RegExp(r'^\d{5}-\d{7}-\d{1}$');
    if (!cnicPattern.hasMatch(value)) {
      return 'Enter a valid CNIC (#####-#######-#)';
    }

    return null; // Valid CNIC
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppTypography.kMedium16.copyWith(
            color: AppColors.kGrey70,
          ),
        ),
        SizedBox(height: AppSpacing.fiveVertical),
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: '12345-1234567-1',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(13),
            TextInputFormatter.withFunction((oldValue, newValue) {
              String text = newValue.text;
              // Add dashes in the correct positions
              if (text.length > 5 && text[5] != '-') {
                text = text.substring(0, 5) + '-' + text.substring(5);
              }
              if (text.length > 13 && text[13] != '-') {
                text = text.substring(0, 13) + '-' + text.substring(13);
              }
              return TextEditingValue(
                text: text,
                selection: TextSelection.collapsed(offset: text.length),
              );
            }),
          ],
          validator: widget.validator,
        ),
      ],
    );
  }
}
