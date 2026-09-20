import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove/app_ctrl.dart';
import 'package:vinyl_groove/core/widget/app_appbar.dart';
import 'package:vinyl_groove/core/widget/base_scaffold.dart';
import 'package:vinyl_groove/core/widget/app_confirm_dialog.dart';
import 'package:vinyl_groove/core/widget/no_result_icon.dart';
import 'package:vinyl_groove/models/album_model.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../main.dart';
import '../../../album/presentation/album_screen.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appCtrl.ticker,
      builder: (context, _, child) {
        return BaseScaffold(
          appBar: AppAppbar(title: '관심 상품'),
          body: appCtrl.likes.isEmpty
              ? Center(
                  child: NoResultIcon(
                    icon: .heart,
                    title: '관심 상품이 없습니다.',
                    subTitle: '마음에 드는 상품에 하트를 눌러보세요.',
                  ),
                )
              : ListView(
                  children: appCtrl.likes.map((e) {
                    return _LikeAlbumTile(album: e);
                  }).toList(),
                ),
        );
      },
    );
  }
}

class _LikeAlbumTile extends StatefulWidget {
  const _LikeAlbumTile({super.key, required this.album});

  final AlbumModel album;

  @override
  State<_LikeAlbumTile> createState() => _LikeAlbumTileState();
}

class _LikeAlbumTileState extends State<_LikeAlbumTile> {
  double x = 0;

  @override
  Widget build(BuildContext context) {
    final e = widget.album;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          x = (x + details.delta.dx).clamp(-180, 0);
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                AppConfirmDialog(
                  title: '관심 상품 삭제',
                  content: '${e.albumName}을(를)\n관심 목록에서 삭제했습니다.',
                  cancelAct: () {
                    context.back();
                    setState(() {});
                  },
                  confirmAct: () {
                    appCtrl.likes.remove(e);
                    appCtrl.save();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${e.albumName}을(를)\n관심 목록에서 삭제했습니다.'),
                        action: SnackBarAction(
                          textColor: AppColor.yellow,
                          label: '실행 취소',
                          onPressed: () {
                            appCtrl.likes.add(e);

                            appCtrl.save();
                          },
                        ),
                      ),
                    );
                    context.back();
                  },
                  confirmL: '삭제',
                ).show(context);
              },
              child: Container(
                color: Colors.red,
                alignment: .centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AppIcon.delete.icon(color: Colors.white, size: 24),
                ),
              ),
            ),
          ),
          AnimatedSlide(
            duration: Duration(milliseconds: 50),
            offset: .new(x / 900, 0),
            child: Material(
              clipBehavior: .hardEdge,
              color: AppColor.background,
              child: InkWell(
                onTap: () {
                  context.go(AlbumScreen(id: e.id));
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    spacing: 12,
                    children: [
                      ClipRRect(
                        borderRadius: .circular(12),
                        child: Image.network(
                          e.albumImage,
                          fit: .cover,
                          width: 72,
                          height: 72,
                        ),
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          spacing: 4,
                          children: [
                            Text(
                              e.albumName,
                              overflow: .ellipsis,

                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: .bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              e.artist,
                              overflow: .ellipsis,

                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 13,
                              ),
                            ),
                            Row(
                              spacing: 8,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(180),
                                    borderRadius: .circular(4),
                                  ),

                                  padding: .symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    e.condition,
                                    overflow: .ellipsis,

                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: .w500,
                                    ),
                                  ),
                                ),

                                Text(
                                  '${e.genre.l}',
                                  overflow: .ellipsis,

                                  style: TextStyle(
                                    color: Colors.white30,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: .end,
                        spacing: 4,
                        children: [
                          Text(
                            NumberFormat('₩#,###').format(e.price),
                            overflow: .ellipsis,

                            style: TextStyle(
                              color: AppColor.yellow,
                              fontWeight: .bold,
                              fontSize: 15,
                            ),
                          ),

                          Text(
                            e.tradeMethod.l,
                            overflow: .ellipsis,

                            style: TextStyle(
                              color: Colors.white30,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
