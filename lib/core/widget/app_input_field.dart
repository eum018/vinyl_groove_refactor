import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_color.dart';

class AppInputField extends StatelessWidget {
  const AppInputField({
    super.key,
    this.controller,
    required this.decoration,
    this.onTap,
    this.onChanged,
  });

  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final InputDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      onChanged: onChanged,
      controller: controller,
      style: TextStyle(color: AppColor.white),
      decoration: decoration,
    );
  }
}
