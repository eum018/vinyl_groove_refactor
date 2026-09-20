import 'package:flutter/material.dart';
import 'package:vinyl_groove/app_ctrl.dart';
import 'package:vinyl_groove/feature/my/widget/base_pin_page.dart';
import 'package:vinyl_groove/feature/my/widget/base_simple_login_page.dart';
import 'package:vinyl_groove/feature/nav_screen.dart';

import '../../../main.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key, required this.checkPins});

  final List<int?> checkPins;

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  String content = '로그인을 위해\n4자리 PIN 번호를 입력해주세요';

  bool error = false;

  Key key = UniqueKey();

  void check(List<int?> pins) {
    if (pins.contains(null)) return;
    for (int i = 0; i < 4; i++) {
      if (pins[i] != widget.checkPins[i]) {
        content = 'PIN 번호가 다릅니다.\n4자리 PIN 번호를 다시 입력해주세요.';
        error = true;
        key = UniqueKey();
        setState(() {});
        return;
      }
    }

    appCtrl.page.value = 0;
    context.go(NavScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BaseSimpleLoginPage(
      child: BasePinPage(
        check: check,
        title: null,
        content: content,
        err: error,
      ),
    );
  }
}
