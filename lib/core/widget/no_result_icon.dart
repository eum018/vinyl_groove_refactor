import 'package:flutter/material.dart';
import 'package:vinyl_groove/main.dart';

import '../theme/app_color.dart';
import '../theme/app_icon.dart';
import '../theme/app_text_style.dart';

class NoResultIcon extends StatelessWidget {
  const NoResultIcon({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  final AppIcon icon;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      spacing: 12,
      children: [
        icon.icon(color: Colors.white30, size: 72),
        AppTextStyle.medium16(color: AppColor.whiteL2).text(title),
        AppTextStyle.medium14(color: AppColor.whiteL3).text(subTitle),
      ],
    );
  }
}
