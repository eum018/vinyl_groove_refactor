import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove/app_ctrl.dart';
import 'package:vinyl_groove/main.dart';

import '../../../../core/theme/app_icon.dart';
import '../../../notification/presentation/screens/alerts_screen.dart';

class MainAppbar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppbar({super.key});

  @override
  State<MainAppbar> createState() => _MainAppbarState();

  @override
  Size get preferredSize => .fromHeight(68);
}

class _MainAppbarState extends State<MainAppbar> {
  @override
  Widget build(BuildContext context) {
    final icon = AppIcon.notification.icon(color: Colors.white, size: 28);

    return ValueListenableBuilder(
      valueListenable: appCtrl.ticker2,
      builder: (context, _, child) {
        final count = appCtrl.alerts?['unreadCount'] ?? 0;
        return AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Image.asset('assets/logo_vertical.png'),
          ),
          leadingWidth: 132,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              style: IconButton.styleFrom(),
              onPressed: () {
                context.go(AlertsScreen());
                //message('알림', g: true);
              },
              icon: count <= 0
                  ? icon
                  : Badge(
                      backgroundColor: Colors.red,
                      label: Text(count > 3 ? '3+' : count.toString()),
                      child: icon,
                    ),
            ),
          ],
        );
      },
    );
  }
}
