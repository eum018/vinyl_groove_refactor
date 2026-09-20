import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_input_style.dart';

class NumberInputField extends StatelessWidget {
  const NumberInputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.node,
    required this.length,
  });

  final TextEditingController controller;
  final String hint;
  final FocusNode node;
  final int length;

  @override
  Widget build(BuildContext context) {
    return TextField(  controller: controller,
      focusNode: node,
      maxLength: length,
      textAlign: .center,
      style: TextStyle(color: AppColor.white),
      decoration: AppInputStyle.base(hint: hint, prefIcon: .lock),
    );
  }
}
