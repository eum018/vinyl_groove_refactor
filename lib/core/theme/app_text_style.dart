import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTextStyle {
  AppTextStyle._();

  /// bold

  static TextStyle bold12({Color? color = AppColor.white}) =>
      TextStyle(color: color, fontWeight: .bold, fontSize: 12);

  static TextStyle bold14({Color color = AppColor.white}) =>
      TextStyle(color: color, fontWeight: .bold, fontSize: 14);

  static TextStyle bold15({Color color = AppColor.white}) =>
      TextStyle(color: color, fontWeight: .bold, fontSize: 15);

  static TextStyle bold16({Color? color = AppColor.white}) =>
      TextStyle(color: color, fontWeight: .bold, fontSize: 16);

  static TextStyle bold18({Color color = AppColor.white}) =>
      TextStyle(color: color, fontWeight: .bold, fontSize: 18);

  static TextStyle bold24({Color color = AppColor.white}) =>
      TextStyle(color: color, fontWeight: .bold, fontSize: 24);

  /// medium
  static TextStyle medium10({Color color = AppColor.white}) =>
      TextStyle(color: color, fontWeight: .w500, fontSize: 10);

  static TextStyle medium12({Color color = AppColor.white}) =>
      TextStyle(color: color, fontWeight: .w500, fontSize: 12);

  static TextStyle medium14({Color color = AppColor.white}) =>
      TextStyle(color: color, fontWeight: .w500);

  static TextStyle medium15({Color color = AppColor.white}) =>
      TextStyle(color: color, fontWeight: .w500, fontSize: 15);

  static TextStyle medium16({Color color = AppColor.white}) =>
      TextStyle(color: color, fontWeight: .w500, fontSize: 16);

  static TextStyle medium18({Color color = AppColor.white}) =>
      TextStyle(color: color, fontWeight: .w500, fontSize: 18);

  /// regular

  static TextStyle regular12({Color color = AppColor.white}) =>
      TextStyle(color: color, fontSize: 12);

  static TextStyle regular14({Color color = AppColor.white}) =>
      TextStyle(color: color);
}

extension QT on TextStyle {
  Text text(String label, {TextAlign? align, TextOverflow? overflow}) =>
      Text(label, textAlign: align, style: this, overflow: overflow);
}
