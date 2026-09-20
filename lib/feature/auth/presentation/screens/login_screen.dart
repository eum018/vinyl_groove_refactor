import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove/app_ctrl.dart';
import 'package:vinyl_groove/core/theme/app_input_style.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';
import 'package:vinyl_groove/core/widget/app_input_field.dart';
import 'package:vinyl_groove/core/widget/base_scaffold.dart';
import 'package:vinyl_groove/core/widget/submit_button.dart';
import 'package:vinyl_groove/feature/auth/presentation/screens/signup_screen.dart';
import 'package:vinyl_groove/feature/auth/presentation/widgets/password_input_field.dart';
import 'package:vinyl_groove/main.dart';

import '../../../../core/theme/app_color.dart';
import '../../../nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final em = TextEditingController();
  final pw = TextEditingController();

  bool hide = false;

  String? emE;
  String? pwE;

  void _login() {
    if (em.text.isEmpty) {
      emE = '이메일은 필수 입니다.';
      setState(() {});
      return;
    }
    if (!RegExp(r'^[^.]*@.*\..*$').hasMatch(em.text)) {
      emE = '이메일은 “@“ 포함 ”.“포함 ”@“ 앞에 ”.“사용 불가의 형식을 따릅니다.';

      setState(() {});
      return;
    }
    emE = null;
    setState(() {});

    if (pw.text.isEmpty) {
      pwE = '비밀번호는 필수 입니다.';
      setState(() {});
      return;
    }

    if (pw.text.length < 6) {
      pwE = '비밀번호는 6자 이상이어야 합니다.';
      setState(() {});
      return;
    }

    if (!RegExp(r'(?=.*[A-Z])(?=.*[a-z])').hasMatch(pw.text)) {
      pwE = '비밀번호는 - 대문자 1자 이상 소문자 1자 이상의 형식을 따릅니다.';
      setState(() {});
      return;
    }

    pwE = null;
    setState(() {});

    post(
      Uri.parse('http://${baseUrl}/auth/login/v2'),
      headers: baseHeader,
      body: jsonEncode({"email": em.text, "password": pw.text}),
    ).then((value) {
      final body = jsonDecode(value.body);

      if (body['success'] ?? false) {
        appCtrl.tkn = body['data']['token'];
        appCtrl.user = body['data']['user'];

        if (mounted) context.go(NavScreen());

        return;
      }

      message((body['errors'] as List?)?.firstOrNull['message']);
    }, onError: (e) => message('서버 통신 에러'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        background: AppColor.black,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 16,
                    children: [
                      Column(
                        crossAxisAlignment: .start,
                        spacing: 8,
                        children: [
                          AppTextStyle.bold24().text('로그인'),
                          AppTextStyle.medium14().text(
                            '계정으로 로그인하여 다양한 서비스를 이용하세요.',
                          ),
                        ],
                      ),

                      SizedBox(),

                      AppInputField(
                        controller: em,
                        decoration: AppInputStyle.base(
                          err: emE,
                          hint: '이메일을 입력해주세요.',
                          prefIcon: .email,
                        ),
                      ),

                      PasswordInputField(
                        controller: pw,
                        hide: hide,
                        err: pwE,
                        act: () {
                          setState(() {
                            hide = !hide;
                          });
                        },
                      ),

                      Row(
                        mainAxisAlignment: .end,
                        children: [
                          TextButton(
                            onPressed: () {
                              message('비밀번호 찾기', g: true);
                            },
                            child: AppTextStyle.regular14(
                              color: AppColor.whiteL1,
                            ).text('비밀번호를 잊으셨나요?'),
                          ),
                        ],
                      ),

                      SubmitButton(label: '로그인', onPressed: _login),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          spacing: 12,
                          children: [
                            Expanded(child: Divider(color: AppColor.whiteL1)),
                            AppTextStyle.medium14(color: AppColor.whiteL1)
                                .text('또는'),
                            Expanded(child: Divider(color: AppColor.whiteL1)),
                          ],
                        ),
                      ),

                      Row(
                        mainAxisAlignment: .center,
                        children: [
                          AppTextStyle.medium14().text('계정이 없으신가요?'),
                          TextButton(
                            onPressed: () {
                              context.go(SignupScreen());
                            },
                            child: AppTextStyle.medium14(color: AppColor.yellow)
                                .text('회원가입'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
