import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove/core/test/signup_validator.dart';
import 'package:vinyl_groove/core/theme/app_input_style.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';
import 'package:vinyl_groove/core/widget/app_back_button.dart';
import 'package:vinyl_groove/core/widget/base_scaffold.dart';
import 'package:vinyl_groove/core/widget/submit_button.dart';
import 'package:vinyl_groove/feature/auth/presentation/widgets/auth_header_image.dart';
import 'package:vinyl_groove/feature/auth/presentation/widgets/number_input_field.dart';
import 'package:vinyl_groove/feature/auth/presentation/widgets/password_input_field.dart';
import 'package:vinyl_groove/main.dart';

import '../../../../core/theme/app_color.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final em = TextEditingController();
  final pw = TextEditingController();
  final pw2 = TextEditingController();
  final na = TextEditingController();
  final ph1 = TextEditingController();
  final ph2 = TextEditingController();
  final ph3 = TextEditingController();

  final f1 = FocusNode();
  final f2 = FocusNode();
  final f3 = FocusNode();

  String? emE;
  String? pwE;
  String? pw2E;
  String? naE;
  String? phE;

  bool hide = true;
  bool hide2 = true;
  bool check = false;

  @override
  void initState() {
    super.initState();
    ph1.addListener(() {
      if (ph1.text.length == 3) {
        f1.nextFocus();
      }
    });
    ph2.addListener(() {
      if (ph2.text.length == 4) {
        f2.nextFocus();
      }
    });
  }

  void _signup() {
    if (!check) {
      message('이용약관 및 개인정보처리방침에 동의해 주세요.');
      return;
    }

    final email = em.text.trim();
    final password = pw.text.trim();
    final passwordConfirm = pw2.text.trim();
    final name = na.text.trim();
    final phone1 = ph1.text.trim();
    final phone2 = ph2.text.trim();
    final phone3 = ph3.text.trim();

    setState(() {
      emE = SignupValidator.emailVerify(email);
      pwE = SignupValidator.passwordVerify(password);
      pw2E = SignupValidator.passwordConfirmVerify(password, passwordConfirm);
      naE = SignupValidator.nameVerify(name);
      phE = SignupValidator.phoneVerify(phone1, phone2, phone3);
    });

    if (emE != name ||
        pwE != null ||
        pw2E != null ||
        naE != null ||
        phE != null) {
      return;
    }

    post(
      Uri.parse('http://${baseUrl}/auth/signup'),
      headers: baseHeader,
      body: jsonEncode({
        "email": email,
        "password": password,
        "name": name,
        "phone": "$phone1-$phone2-$phone3",
      }),
    ).then((value) {
      final body = jsonDecode(value.body);

      if (body['success'] ?? false) {
        message('회원가입이 완료되었습니다.');
        context.back();
        return;
      }
    }, onError: (e) => message('서버 통신 에러'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        background: AppColor.black,
        body: Stack(
          children: [
            AuthHeaderImage(showImage: false),

            Column(
              crossAxisAlignment: .start,
              children: [
                AppBackButton(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 72),

                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisSize: .min,
                            spacing: 8,
                            children: [
                              Image.asset(
                                'assets/logo_horizontal.png',
                                width: 160,
                              ),

                              Text(
                                'Vinyl Record Secondhand Marketplace',
                                style: TextStyle(
                                  color: AppColor.whiteL1,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: .start,
                            spacing: 16,
                            children: [
                              Column(
                                crossAxisAlignment: .start,
                                spacing: 8,
                                children: [
                                  AppTextStyle.bold24().text('회원가입'),

                                  AppTextStyle.regular14().text(
                                    '회원 정보를 입력하여 계정을 만들어주세요.',
                                  ),
                                ],
                              ),

                              SizedBox(),
                              _Section(
                                label: '이메일',
                                child: TextField(
                                  controller: em,
                                  style: TextStyle(color: AppColor.white),
                                  decoration: AppInputStyle.base(
                                    err: emE,
                                    hint: '이메일을 입력해주세요.',
                                    prefIcon: .email,
                                  ),
                                ),
                              ),
                              _Section(
                                label: '비밀번호',
                                child: Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    PasswordInputField(
                                      controller: pw,
                                      hide: hide,
                                      err: pwE,
                                      act: () {},
                                    ),
                                    Text(
                                      '8자 이상, 대소문자, 숫자, 특수문자 포함',
                                      style: TextStyle(
                                        color: AppColor.whiteL1,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              _Section(
                                label: '비밀번호 확인',
                                child: PasswordInputField(
                                  controller: pw2,
                                  hint: '비밀번호를 다시 입력해주세요.',
                                  hide: hide2,
                                  err: pw2E,
                                  act: () {
                                    setState(() {
                                      hide2 = !hide2;
                                    });
                                  },
                                ),
                              ),

                              _Section(
                                label: '이름',
                                child: TextField(
                                  controller: na,
                                  style: TextStyle(color: AppColor.white),
                                  decoration: AppInputStyle.base(
                                    hint: '이름을 입력해주세요.',
                                    prefIcon: .person,
                                    err: naE,
                                  ),
                                ),
                              ),

                              _Section(label: '휴대폰 번호', child: numberForm()),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      activeColor: AppColor.yellow,
                                      side: BorderSide(
                                        color: AppColor.white,
                                        width: 2,
                                      ),
                                      value: check,
                                      onChanged: (value) {
                                        setState(() {
                                          check = !check;
                                        });
                                      },
                                    ),
                                    AppTextStyle.medium14(
                                      color: AppColor.whiteL1,
                                    ).text('이용약관 및 개인정보처리방침에 동의합니다.'),
                                  ],
                                ),
                              ),

                              SubmitButton(label: '회원가입', onPressed: _signup),

                              Row(
                                mainAxisAlignment: .center,
                                children: [
                                  Text(
                                    '이미 계정이 있으신가요?',
                                    style: TextStyle(
                                      color: AppColor.whiteL1,
                                      fontWeight: .w500,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.back();
                                    },
                                    child: AppTextStyle.regular14(
                                      color: AppColor.yellow,
                                    ).text('로그인'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row numberForm() {
    final divider = SizedBox(
      width: 24,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Divider(color: AppColor.white),
      ),
    );

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: NumberInputField(
            controller: ph1,
            node: f1,
            hint: '010',
            length: 3,
          ),
        ),

        divider,

        Expanded(
          flex: 4,
          child: NumberInputField(
            controller: ph2,
            hint: '1234',
            node: f2,
            length: 4,
          ),
        ),

        divider,

        Expanded(
          flex: 4,
          child: NumberInputField(
            controller: ph3,
            hint: '5678',
            node: f3,
            length: 4,
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    super.key,
    this.required = true,
    required this.child,
    required this.label,
  });

  final bool required;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 8,
      children: [
        Row(
          children: [
            AppTextStyle.medium14().text(label),
            if (required) AppTextStyle.medium14(color: AppColor.red).text(' *'),
          ],
        ),
        child,
      ],
    );
  }
}
