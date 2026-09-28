import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_groove/app_ctrl.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';
import 'package:vinyl_groove/core/widget/app_appbar.dart';
import 'package:vinyl_groove/core/widget/app_confirm_dialog.dart';
import 'package:vinyl_groove/core/widget/base_scaffold.dart';
import 'package:vinyl_groove/feature/my/presentation/pin_screen.dart';
import 'package:vinyl_groove/feature/my/widget/base_simple_login_page.dart';

import '../../../core/theme/app_icon.dart';
import '../../../main.dart';
import '../../album/presentation/album_screen.dart';
import '../../album/presentation/my_regi_screen.dart';
import '../../album/presentation/regi_screen.dart';
import '../../auth/presentation/screens/login_screen.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    final divider = Divider(color: AppColor.blackL2, height: 1);
    return BaseScaffold(
      appBar: AppAppbar(title: '마이페이지'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 16,
            children: [
              _profile(),

              Column(
                children: [
                  _Tile(
                    onTap: () {
                      context.go(RegiScreen());
                    },
                    label: '상품 등록',
                    pref: .add,
                  ),
                  _Tile(
                    onTap: () {
                      context.go(MyRegiScreen());
                    },
                    label: '내 등록 상품',
                    pref: .inventory,
                  ),
                ],
              ),

              divider,

              Column(
                children: [
                  _Tile(
                    onTap: () {
                      message('판매 내역', g: true);
                    },
                    label: '판매 내역',
                    pref: .shopping,
                  ),
                  _Tile(
                    onTap: () {
                      message('구매 내역', g: true);
                    },
                    label: '구매 내역',
                    pref: .history,
                  ),
                ],
              ),

              divider,

              Column(
                children: [
                  _Tile(
                    onTap: () {
                      message('고객센터', g: true);
                    },
                    label: '고객센터',
                    pref: .help,
                  ),

                  _Tile(
                    onTap: () {
                      message('앱 정보', g: true);
                    },
                    label: '앱 정보',
                    pref: .info,
                  ),
                ],
              ),
              divider,

              Column(
                children: [
                  _Tile(
                    onTap: () {
                      context.go(PinScreen());
                    },
                    label: 'PIN 번호 간편 로그인',
                    pref: .pin,
                  ),
                  _Tile(
                    onTap: () {
                      message('지문 등록 기능은 구현되지 않았습니다.');

                      context.go(BaseSimpleLoginPage(child: SizedBox()));
                    },
                    label: '지문 인증 간편 로그인',
                    pref: .finger,
                  ),
                ],
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.background,
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red),
                  padding: .symmetric(vertical: 14),
                ),
                onPressed: () {
                  AppConfirmDialog(
                    title: '정말 로그아웃 하시겠습니까?',
                    cancelAct: () {
                      context.back();
                    },
                    confirmAct: () {
                      appCtrl.tkn = null;
                      appCtrl.user = null;
                      context.re(LoginScreen());
                    },
                    confirmL: '로그아웃',
                  ).show(context);
                },
                child: Row(
                  mainAxisAlignment: .center,
                  children: [AppTextStyle.bold16(color: null).text('로그아웃')],
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Material _profile() {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      color: AppColor.blackL2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          spacing: 12,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColor.yellow.withAlpha(80),
              child: AppIcon.person.icon(color: AppColor.yellow, size: 28),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 4,
                children: [
                  AppTextStyle.bold16().text(appCtrl.user?['name'] ?? ''),
                  AppTextStyle.medium12(color: AppColor.whiteL1)
                      .text(appCtrl.user?['email'] ?? ''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    super.key,
    required this.onTap,
    required this.label,
    required this.pref,
  });

  final VoidCallback onTap;
  final String label;
  final AppIcon pref;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: .hardEdge,
      color: AppColor.background,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            spacing: 16,
            children: [
              pref.icon(color: Colors.white60, size: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 4,
                  children: [
                    AppTextStyle.medium16(color: AppColor.whiteL1).text(label),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
