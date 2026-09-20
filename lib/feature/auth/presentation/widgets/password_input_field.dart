import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_input_style.dart';
import '../../../../main.dart';

class PasswordInputField extends StatelessWidget {
  const PasswordInputField({
    super.key,
    required this.controller,
    required this.hide,
    required this.act,
    this.hint = '비밀번호를 입력해주세요.',
    required this.err,
  });

  final TextEditingController controller;
  final bool hide;
  final String hint;
  final VoidCallback act;
  final String? err;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscuringCharacter: "*",
      obscureText: hide,
      style: TextStyle(color: AppColor.white),
      decoration: AppInputStyle.base(
        hint: hint,
        err: err,
        prefIcon: .lock,
        suf: IconButton(
          onPressed: act,
          icon: (hide ? AppIcon.visibilityoff : AppIcon.visibility).icon(
            color: AppColor.whiteL1,
          ),
        ),
      ),
    );
  }
}
