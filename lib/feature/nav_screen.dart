import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vinyl_groove/app_ctrl.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';
import 'package:vinyl_groove/core/widget/base_scaffold.dart';

import '../core/theme/app_icon.dart';
import '../main.dart';
import 'album/presentation/regi_screen.dart';
import 'main/presentation/screens/home_screen.dart';
import 'main/presentation/screens/like_screen.dart';
import 'main/presentation/screens/search_screen.dart';
import 'my/presentation/my_screen.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      appCtrl.loadAlerts();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      appCtrl.loadAlerts();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appCtrl.page,
      builder: (context, value, child) {
        return BaseScaffold(
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColor.blackL2,
            currentIndex: value,
            selectedItemColor: AppColor.yellow,
            unselectedItemColor: Colors.white60,
            type: .fixed,
            onTap: (value) {
              if (value == 2) {
                context.go(RegiScreen());
                return;
              }

              appCtrl.page.value = value;
            },
            items:
                [
                  (AppIcon.home, '홈'),
                  (AppIcon.search, '탐색'),
                  (AppIcon.search, '탐색'),
                  (AppIcon.heart, '관심상품'),
                  (AppIcon.mypage, '마이페이지'),
                ].indexed.map((e) {
                  if (e.$1 == 2) {
                    return BottomNavigationBarItem(
                      icon: CircleAvatar(
                        backgroundColor: AppColor.yellow,
                        radius: 28,
                        child: Icon(Icons.add, color: Colors.black),
                      ),
                      label: '',
                    );
                  }

                  return BottomNavigationBarItem(
                    icon: e.$2.$1.icon(
                      color: e.$1 == value ? AppColor.yellow : AppColor.whiteL1,
                    ),
                    label: e.$2.$2,
                  );
                }).toList(),
          ),
          body: Builder(
            builder: (context) {
              final pages = [
                HomeScreen(),
                SearchScreen(),
                SizedBox(),
                LikeScreen(),
                MyScreen(),
              ];
              return pages[value];
            },
          ),
        );
      },
    );
  }
}
