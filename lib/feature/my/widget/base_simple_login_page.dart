import 'package:flutter/material.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';
import 'package:vinyl_groove/core/widget/app_appbar.dart';
import 'package:vinyl_groove/core/widget/base_scaffold.dart';

import '../../../main.dart';
import '../../auth/presentation/screens/login_screen.dart';

class BaseSimpleLoginPage extends StatelessWidget {
  const BaseSimpleLoginPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppAppbar(title: '간편 로그인', center: true),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            child,

            SizedBox(height: 48),

            TextButton(
              onPressed: () {
                context.go(LoginScreen());
              },
              child: AppTextStyle.medium14(color: AppColor.yellow)
                  .text('다른 계정으로 로그인하기'),
            ),
          ],
        ),
      ),
    );
  }
}
