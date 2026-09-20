import 'package:flutter/material.dart';

import '../../main.dart';
import '../theme/app_color.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.ios = true});

  final bool ios;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(),
      onPressed: () {
        context.back();
      },
      icon: Icon(
        ios ? Icons.arrow_back_ios : Icons.arrow_back,
        color: AppColor.white,
      ),
    );
  }
}
