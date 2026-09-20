import 'package:flutter/material.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';

import '../../main.dart';

class AppInputStyle {
  AppInputStyle._();

  static base({
    String? hint,
    String? err,
    AppIcon? prefIcon,
    Widget? pref,
    Widget? suf,
  }) => InputDecoration(
    counterText: "",
    filled: true,
    fillColor: AppColor.blackL1,
    hintStyle: TextStyle(color: AppColor.whiteL1),
    hintText: hint,
    prefixIcon:
        pref ??
        (prefIcon != null
            ? Padding(
                padding: const EdgeInsets.all(11.0),
                child: prefIcon.icon(color: AppColor.whiteL1),
              )
            : null),
    errorText: err,
    errorMaxLines: 2,
    suffixIcon: suf,
    border: OutlineInputBorder(borderRadius: .circular(12)),
    focusedBorder: OutlineInputBorder(
      borderRadius: .circular(12),
      borderSide: BorderSide(color: AppColor.yellow),
    ),
  );
}
