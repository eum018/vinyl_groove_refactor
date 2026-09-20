import 'package:flutter/material.dart';

import '../theme/app_color.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.background = AppColor.background,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final BottomNavigationBar? bottomNavigationBar;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: body,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        backgroundColor: background,
      ),
    );
  }
}
