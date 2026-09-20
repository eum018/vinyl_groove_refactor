import 'package:flutter/material.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';

import '../theme/app_text_style.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, this.onPressed, required this.label});

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.yellow,
        foregroundColor: AppColor.background,
        shape: RoundedRectangleBorder(borderRadius: .circular(12)),
        padding: .symmetric(vertical: 14),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: .center,
        children: [Text(label, style: AppTextStyle.bold16())],
      ),
    );
  }
}
