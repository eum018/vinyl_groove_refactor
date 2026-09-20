import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vinyl_groove/app_ctrl.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';
import 'package:vinyl_groove/core/theme/app_input_style.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';
import 'package:vinyl_groove/core/widget/app_appbar.dart';
import 'package:vinyl_groove/core/widget/app_input_field.dart';
import 'package:vinyl_groove/core/widget/base_scaffold.dart';
import 'package:vinyl_groove/core/widget/submit_button.dart';
import 'package:vinyl_groove/feature/main/presentation/widgets/filter_button.dart';

import '../../../main.dart';

class RegiScreen extends StatefulWidget {
  const RegiScreen({super.key});

  @override
  State<RegiScreen> createState() => _RegiScreenState();
}

class _RegiScreenState extends State<RegiScreen> {
  String? image;

  Uint8List? bytes;

  final na = TextEditingController();
  final ar = TextEditingController();
  final pr = TextEditingController();
  final ba = TextEditingController();
  final de = TextEditingController();

  Genre? gen = .ROCK;
  Con? con = .SS;
  Trade? trd = .DIRECT;

  String? imE;
  String? naE;
  String? arE;
  String? prE;
  String? genE;
  String? conE;
  String? trdE;

  void error(e) {
    imE = null;
    naE = null;
    arE = null;
    prE = null;
    genE = null;
    conE = null;
    trdE = null;

    switch (e['field']) {
      case 'albumImage':
        imE = e['message'];
      case 'albumName':
        naE = e['message'];
      case 'artist':
        arE = e['message'];
      case 'genre':
        genE = e['message'];
      case 'condition':
        conE = e['message'];
      case 'price':
        prE = e['message'];
      case 'tradeMethod':
        trdE = e['message'];
    }
    setState(() {});
  }

  Future<dynamic> postImage(XFile? img) =>
      post(
        Uri.parse('http://${baseUrl}/upload/image'),
        headers: baseHeader,
        body: jsonEncode({
          "image":
              "data:${img?.mimeType ?? 'image/png'};base64,${base64Encode(bytes!)}",
          "type": "ALBUM",
        }),
      ).then((value) async {
        if (value.statusCode == 429) return null;

        final body = jsonDecode(value.body);
        if (body['success'] ?? false) {
          message(body['message']);

          this.image = body['data']['imageUrl'];

          return body;
        }

        message((body['errors'] as List?)?.firstOrNull['message']);
      }, onError: (e) => message('서버 통신 에러'));

  Future<dynamic> register() =>
      post(
        Uri.parse('http://${baseUrl}/products'),
        headers: baseHeader,
        body: jsonEncode({
          "albumName": na.text,
          "artist": ar.text,
          "genre": gen?.v,
          "condition": con?.v,
          "price": int.tryParse(pr.text) ?? 0,
          "tradeMethod": trd?.v,
          "barcode": ba.text,
          "description": de.text,
          "albumImage": image,
        }),
      ).then((value) async {
        if (value.statusCode == 429) return null;

        final body = jsonDecode(value.body);

        if (body['success'] ?? false) {
          message(body['message']);
          context.back();

          return body;
        }

        error((body['errors'] as List?)?.first);
      }, onError: (e) => message('서버 통신 에러'));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        appBar: AppAppbar(title: '상품 등록', showBack: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                _Section(err: imE, child: _imageBox()),

                _Section(
                  child: _form(
                    label: '앨범명 *',
                    child: AppInputField(
                      decoration: AppInputStyle.base(
                        hint: '앨범명을 입력하세요',
                        err: naE,
                      ),
                      controller: na,
                    ),
                  ),
                ),

                _Section(
                  child: _form(
                    label: '아티스트 *',
                    child: AppInputField(
                      decoration: AppInputStyle.base(
                        hint: '아티스트명을 입력하세요',
                        err: arE,
                      ),
                      controller: ar,
                    ),
                  ),
                ),

                _Section(
                  err: genE,
                  child: _form(
                    label: '장르 *',
                    child: SizedBox(
                      width: .infinity,
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: Genre.values.map((e) {
                          final act = gen == e;
                          return FilterButton(
                            selected: act,
                            onPressed: () {
                              setState(() {
                                if (act) {
                                  gen = null;
                                } else {
                                  gen = e;
                                }
                              });
                            },
                            label: e.l,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                _Section(
                  err: genE,
                  child: _form(
                    label: '음반 상태 *',
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: .start,
                      children: [
                        SizedBox(
                          width: .infinity,
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: Con.values.map((e) {
                              final act = con == e;
                              return FilterButton(
                                selected: act,
                                onPressed: () {
                                  setState(() {
                                    if (act) {
                                      con = null;
                                    } else {
                                      con = e;
                                    }
                                  });
                                },
                                label: e.v,
                              );
                            }).toList(),
                          ),
                        ),

                        if (con != null)
                          AppTextStyle.regular14(color: AppColor.whiteL1)
                              .text(con!.l),
                      ],
                    ),
                  ),
                ),

                _Section(
                  child: _form(
                    label: '가격 *',
                    child: AppInputField(
                      decoration: AppInputStyle.base(
                        hint: '가격을 입력하세요',
                        err: prE,
                        pref: SizedBox(),
                      ),
                      controller: pr,
                    ),
                  ),
                ),
                _Section(
                  err: genE,
                  child: _form(
                    label: '거래 방식 *',
                    child: SizedBox(
                      width: .infinity,
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: Trade.values.map((e) {
                          final act = trd == e;

                          return FilterButton(
                            selected: act,
                            onPressed: () {
                              setState(() {
                                if (act) {
                                  trd = null;
                                } else {
                                  trd = e;
                                }
                              });
                            },
                            label: e.l,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                _form(
                  label: '바코드 번호',
                  child: AppInputField(
                    decoration: AppInputStyle.base(hint: '바코드 번호 (선택)'),
                    controller: ba,
                  ),
                ),
                _form(
                  label: '상품 설명',
                  child: AppInputField(
                    decoration: AppInputStyle.base(hint: '상품에 대한 상세 설명을 입력하세요'),
                    controller: de,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SubmitButton(label: '등록하기', onPressed: register),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _form({required String label, required Widget child}) => Column(
    crossAxisAlignment: .start,
    spacing: 8,
    children: [
      AppTextStyle.bold14(color: AppColor.white).text(label),
      child,
    ],
  );

  PopupMenuButton<dynamic> _imageBox() {
    select(ImageSource src) async {
      final image = await ImagePicker().pickImage(source: src);
      bytes = await image?.readAsBytes();

      if (bytes != null) {
        postImage(image);
      }

      setState(() {});
    }

    return PopupMenuButton(
      color: AppColor.blackL2,
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () => select(.camera),
          child: AppTextStyle.regular14(color: AppColor.whiteL1)
              .text('카메라로 촬영'),
        ),
        PopupMenuItem(
          onTap: () => select(.gallery),
          child: AppTextStyle.regular14(color: AppColor.whiteL1)
              .text('갤러리에서 선택'),
        ),
      ],
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: .circular(12),
          color: AppColor.blackL2,
        ),
        foregroundDecoration: BoxDecoration(
          image: bytes == null
              ? null
              : DecorationImage(image: MemoryImage(bytes!)),
        ),
        alignment: .center,
        child: Column(
          mainAxisSize: .min,
          spacing: 4,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.white30,
              size: 52,
            ),

            AppTextStyle.medium14(color: AppColor.whiteL3)
                .text('상품 이미지를 등록하세요'),
            AppTextStyle.regular12().text('터치하여 카메라/갤러리 선택'),
          ],
        ),
      ),
    );
  }
}

enum Con {
  SS('SS', '미개봉 새상품'),
  M('M', 'Mint - 완벽한 상태'),
  NM('NM', 'Near Mint - 거의 새것'),
  EX('EX', 'Excellent - 약간의 사용감'),
  VG_P('VG+', 'Very Good+ - 양호'),
  VG('VG', 'Very Good - 사용감 있음'),
  G('G', 'Good - 재생 가능');

  final String v;
  final String l;

  const new(this.v, this.l);
}

class _Section extends StatelessWidget {
  const _Section({super.key, this.err, required this.child});

  final Widget child;
  final String? err;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 8,
      children: [
        child,
        if (err != null) AppTextStyle.regular14(color: AppColor.red).text(err!),
      ],
    );
  }
}
