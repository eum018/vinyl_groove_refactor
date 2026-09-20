import 'package:flutter/material.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';

import '../../main.dart';

class AppAppbar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppbar({
    super.key,
    required this.title,
    this.showBack = false,
    this.ios = false,
    this.actions,
    this.center = false,
  });

  final bool center;
  final List<Widget>? actions;
  final String title;
  final bool showBack;
  final bool ios;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: center,
      actions: actions,
      leading: IconButton(
        style: IconButton.styleFrom(),
        onPressed: () {
          context.back();
        },
        icon: Icon(
          ios ? Icons.arrow_back_ios : Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      title: Text(title, style: AppTextStyle.bold16()),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => .fromHeight(68);
}
