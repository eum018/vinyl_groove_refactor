import 'package:flutter/material.dart';
import 'package:vinyl_groove/feature/my/presentation/pin_login_screen.dart';
import 'package:vinyl_groove/feature/my/widget/base_pin_page.dart';

import '../../../main.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String content = '4자리 PIN 번호를 입력해주세요';

  bool error = false;

  void check(List<int?> pins) {
    if (pins.contains(null)) return;

    if (pins[0] == pins[1] && pins[0] == pins[2] && pins[0] == pins[3]) {
      content = 'PIN번호는 동일 숫자 4자리를 입력할 수 없습니다.';
      error = true;
      setState(() {});
      return;
    }

    context.re(PinCheckScreen(checkPins: pins));
  }

  @override
  Widget build(BuildContext context) {
    return BasePinPage(
      check: check,
      title: 'PIN 번호를 설정해주세요',
      content: content,
      err: error,
    );
  }
}

class PinCheckScreen extends StatefulWidget {
  const PinCheckScreen({required this.checkPins});

  final List<int?> checkPins;

  @override
  State<PinCheckScreen> createState() => _PinCheckScreenState();
}

class _PinCheckScreenState extends State<PinCheckScreen> {
  String content = '같은 PIN 번호를 다시 입력해주세요';

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

    context.go(PinLoginScreen(checkPins: pins));
  }

  @override
  Widget build(BuildContext context) {
    return BasePinPage(
      key: key,
      check: check,
      title: 'PIN 번호를 재확인해주세요',
      content: content,
      err: error,
    );
  }
}
