import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove/app_ctrl.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';
import 'package:vinyl_groove/core/widget/submit_button.dart';
import 'package:vinyl_groove/feature/main/presentation/widgets/filter_button.dart';
import 'package:vinyl_groove/models/album_model.dart';
import 'package:vinyl_groove/feature/album/widgets/like_button.dart';

import '../../../main.dart';
import '../widgets/album_card.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key, required this.id});

  final int id;

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  AlbumModel? album;
  late Map info;

  final _controller = ScrollController();

  List<AlbumModel> albums = [];

  Future<void> load() async {
    final res = await appCtrl.loadAlbums(limit: 3, keyword: album?.artist);

    if (res != null) {
      albums.addAll(res['data']);
      if (mounted) setState(() {});
    }
  }

  bool scroll = false;

  bool run = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await get(
        Uri.parse('http://${baseUrl}/products/${widget.id}'),
        headers: baseHeader,
      ).then((value) async {
        if (value.statusCode == 429) return;

        if (value.statusCode == 200) {
          final body = jsonDecode(value.body);

          if (body['success'] ?? false) {
            album = AlbumModel.from(body['data']);
            info = body['data'];
            load();

            if (mounted) setState(() {});

            return;
          }

          message((body['errors'] as List?)?.firstOrNull['message']);
        }
      }, onError: (e) => message('서버 통신 에러'));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final album = this.album;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.background,
        body: album == null
            ? Center(child: CircularProgressIndicator(color: AppColor.yellow))
            : Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [_appbar(album, context), _body(album)],
                    ),
                  ),

                  Container(
                    color: AppColor.blackL2,
                    padding: .all(16),
                    child: SubmitButton(
                      label: '구매하기',
                      onPressed: () {
                        message('구매', g: true);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  SliverToBoxAdapter _body(AlbumModel album) {
    Widget section({
      required String title,
      Widget? headerSuffix,
      required String content,
    }) => Column(
      crossAxisAlignment: .start,
      spacing: 8,
      children: [
        Row(
          spacing: 8,
          children: [AppTextStyle.bold18().text(title), ?headerSuffix],
        ),

        AppTextStyle.regular14(color: AppColor.whiteL1).text(content),
      ],
    );

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 24,
          children: [
            Column(
              crossAxisAlignment: .start,
              spacing: 16,

              children: [
                Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    AppTextStyle.bold24().text(album.albumName),
                    AppTextStyle.medium16().text(album.artist),
                  ],
                ),

                Row(
                  spacing: 8,
                  children: [
                    FilterButton(
                      selected: false,
                      onPressed: null,
                      label: album.genre.l,
                    ),
                    FilterButton(
                      selected: false,
                      onPressed: null,
                      label: album.condition,
                    ),
                    FilterButton(
                      selected: false,
                      onPressed: null,
                      label: album.tradeMethod.l,
                    ),
                  ],
                ),

                Builder(
                  builder: (context) {
                    final seller = info['seller'];

                    return Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(12),
                      ),
                      color: AppColor.blackL2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          spacing: 12,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              onBackgroundImageError: (exception, stackTrace) =>
                                  SizedBox(),
                              backgroundImage: NetworkImage(
                                (seller['profileImage'] as String?)
                                        ?.replaceFirst(
                                          '192.168.100.200',
                                          baseUrl,
                                        ) ??
                                    '',
                              ),
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                spacing: 4,
                                children: [
                                  AppTextStyle.bold16().text(seller['name']),
                                  AppTextStyle.medium12(color: AppColor.whiteL1)
                                      .text(seller['email']),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white60,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            section(
              content: info['conditionDescription'],
              title: '상품 상태',
              headerSuffix: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(180),
                  borderRadius: .circular(4),
                ),

                padding: .symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  album.condition,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: .w500,
                  ),
                ),
              ),
            ),

            section(title: '상품 설명', content: info['description']),

            Material(
              shape: RoundedRectangleBorder(borderRadius: .circular(12)),
              color: AppColor.blackL2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        spacing: 4,
                        children: [
                          AppTextStyle.bold24(color: AppColor.yellow)
                              .text('가격'),
                          AppTextStyle.bold24(color: AppColor.yellow)
                              .text(NumberFormat('₩#,###').format(album.price)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: .end,
                      spacing: 4,
                      children: [
                        AppTextStyle.medium12(color: AppColor.whiteL1)
                            .text('거래 방식'),
                        AppTextStyle.medium18().text(album.tradeMethod.l),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: SingleChildScrollView(
                controller: _controller,
                scrollDirection: .horizontal,
                padding: .symmetric(horizontal: 16),
                child: Row(
                  spacing: 12,
                  children: albums.map((e) => AlbumCard(album: e)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _appbar(AlbumModel album, BuildContext context) {
    return SliverAppBar(
      actions: [LikeButton(albumModel: album, size: 28)],
      backgroundColor: Colors.transparent,
      leading: IconButton(
        style: IconButton.styleFrom(backgroundColor: Colors.black54),
        onPressed: () {
          context.back();
        },
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      expandedHeight: 300,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(album.albumImage),
            fit: .fitWidth,
          ),
        ),
        foregroundDecoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.background, Colors.black12, Colors.black12],
            begin: .bottomCenter,
            end: .topCenter,
          ),
        ),
      ),
    );
  }
}
