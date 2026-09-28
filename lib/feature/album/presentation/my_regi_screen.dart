import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';
import 'package:vinyl_groove/core/widget/app_appbar.dart';
import 'package:vinyl_groove/core/widget/app_confirm_dialog.dart';

import '../../../core/theme/app_icon.dart';
import '../../../main.dart';
import '../../../models/album_model.dart';
import 'album_screen.dart';

class MyRegiScreen extends StatefulWidget {
  const MyRegiScreen({super.key});

  @override
  State<MyRegiScreen> createState() => _MyRegiScreenState();
}

class _MyRegiScreenState extends State<MyRegiScreen> {
  List<AlbumModel> albums = [];

  Future<void> load() async {
    await get(
      Uri.parse('http://${baseUrl}/products/me'),
      headers: baseHeader,
    ).then((value) async {
      if (value.statusCode == 429) return null;

      final body = jsonDecode(value.body);

      if (body['success'] ?? false) {
        albums = (body['data'] as List).map((e) => AlbumModel.from(e)).toList();
        if (mounted) setState(() {});

        return body;
      }

      message((body['errors'] as List?)?.firstOrNull['message']);
    }, onError: (e) => message('서버 통신 에러'));
  }

  Future<dynamic> remove(int id) =>
      delete(
        Uri.parse('http://${baseUrl}/products/$id'),
        headers: baseHeader,
      ).then((value) async {
        if (value.statusCode == 429) return null;

        final body = jsonDecode(value.body);

        if (body['success'] ?? false) {
          message('상품이 삭제되었습니다');
          load();

          return body;
        }

        message((body['errors'] as List?)?.firstOrNull['message']);
      }, onError: (e) => message('서버 통신 에러'));

  @override
  void initState() {
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) async {
      load();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppAppbar(title: '내 등록 상품'),
        body: RefreshIndicator(
          onRefresh: load,
          child: albums.isEmpty
              ? LayoutBuilder(
                  builder: (context, constraints) => ListView(
                    children: [
                      SizedBox(
                        height: constraints.maxHeight,
                        child: Center(
                          child: AppTextStyle.bold14().text('등록된 상품이 없습니다.'),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  children: albums.map((e) => _albumTile(context, e)).toList(),
                ),
        ),
      ),
    );
  }

  Padding _albumTile(BuildContext context, AlbumModel e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: .circular(12)),
        clipBehavior: .hardEdge,
        color: AppColor.blackL2,
        child: InkWell(
          onTap: () async {
            context.go(AlbumScreen(id: e.id));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 12,
              children: [
                ClipRRect(
                  borderRadius: .circular(12),
                  child: Image.network(
                    errorBuilder: (context, error, stackTrace) => SizedBox(),
                    e.albumImage,
                    fit: .cover,
                    width: 82,
                    height: 82,
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 4,
                    children: [
                      AppTextStyle.bold15().text(e.albumName),

                      AppTextStyle.regular14(color: AppColor.whiteL1)
                          .text(e.artist),

                      Row(
                        spacing: 8,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(180),
                              borderRadius: .circular(4),
                            ),
                            padding: .symmetric(vertical: 4, horizontal: 8),
                            child: AppTextStyle.medium10(
                              color: AppColor.whiteL1,
                            ).text(e.condition.v),
                          ),
                          AppTextStyle.bold15(color: AppColor.yellow)
                              .text(NumberFormat('₩#,###').format(e.price)),
                        ],
                      ),
                    ],
                  ),
                ),

                Builder(
                  builder: (context) {
                    Widget iconButton({
                      required VoidCallback onTap,
                      required AppIcon icon,
                    }) => IconButton(
                      style: IconButton.styleFrom(
                        minimumSize: .zero,
                        padding: .zero,
                      ),
                      onPressed: onTap,
                      icon: icon.icon(color: Colors.white60, size: 24),
                    );

                    return Column(
                      crossAxisAlignment: .end,
                      spacing: 4,
                      children: [
                        iconButton(
                          onTap: () {
                            message('앨범 수정', g: true);
                            load();
                          },
                          icon: .edit,
                        ),

                        iconButton(
                          onTap: () {
                            AppConfirmDialog(
                              title: '${e.albumName}을(를)\n삭제하시겠습니까',
                              cancelAct: () {
                                context.back();
                              },
                              confirmAct: () {
                                remove(e.id);
                                context.back();
                              },
                            ).show(context);
                          },
                          icon: .delete,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
