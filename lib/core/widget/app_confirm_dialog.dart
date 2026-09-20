import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.cancelAct,
    required this.confirmAct,
    this.confirmL = '삭제',
    this.cancelL = "취소",
    this.content,
  });

  final String title;
  final String? content;
  final VoidCallback cancelAct;
  final VoidCallback confirmAct;
  final String cancelL;
  final String confirmL;

  Future<dynamic> show(BuildContext context) =>
      showCupertinoDialog(context: context, builder: (context) => this);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: AppTextStyle.regular14(color: AppColor.black).text(title),
      content: content != null
          ? AppTextStyle.regular14(color: AppColor.black).text(content!)
          : null,
      actions: [
        CupertinoButton(
          onPressed: cancelAct,
          child: AppTextStyle.medium12(color: AppColor.black).text(cancelL),
        ),
        CupertinoButton(
          onPressed: confirmAct,
          child: AppTextStyle.medium12(color: AppColor.black).text(confirmL),
        ),
      ],
    );
  }
}
