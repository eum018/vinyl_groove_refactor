import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove/app_ctrl.dart';
import 'package:vinyl_groove/main.dart';

import '../../../../core/theme/app_icon.dart';
import '../../../album/presentation/album_screen.dart';
import '../../../barcode/barcode_screen.dart';

class BarcodeButton extends StatefulWidget {
  const BarcodeButton({super.key});

  @override
  State<BarcodeButton> createState() => _BarcodeButtonState();
}

class _BarcodeButtonState extends State<BarcodeButton> {
  void _search(String res) =>
      get(
        Uri.parse('http://${baseUrl}/products?barcode=${res}'),
        headers: baseHeader,
      ).then((value) async {
        if (value.statusCode == 200) {
          final body = jsonDecode(value.body);
          if (body['success'] ?? false) {
            final data = body['data'] as List;

            if (data.isEmpty) {
              message('바코드 "${res}"에\n해당하는 상품을 찾을 수 없습니다');
              return;
            }

            context.go(AlbumScreen(id: data.first['id']));

            return body;
          }

          message((body['errors'] as List?)?.firstOrNull['message']);
        }
      }, onError: (e) => message('서버 통신 에러'));

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(),
      onPressed: () async {
        String? res = await context.go(BarcodeScreen());

        if (res != null) {
          res = res.padLeft(13, '0');
          _search(res);
        }

        //message('바코드 검색', g: true);
      },
      icon: AppIcon.barcode.icon(color: Colors.white60, size: 26),
    );
  }
}
