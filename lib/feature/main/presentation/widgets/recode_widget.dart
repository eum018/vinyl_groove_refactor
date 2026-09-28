import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';
import 'package:vinyl_groove/feature/main/presentation/widgets/filter_button.dart';
import 'package:vinyl_groove/main.dart';

import '../../../../app_ctrl.dart';
import '../../../../core/enum/sort.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../models/album_model.dart';
import '../../../album/presentation/album_screen.dart';

class RecodeWidget extends StatefulWidget {
  const RecodeWidget({super.key});

  @override
  State<RecodeWidget> createState() => _RecodeWidgetState();
}

class _RecodeWidgetState extends State<RecodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List<AlbumModel> albums = [];

  Future<void> load() async {
    final res = await appCtrl.loadAlbums(limit: 5, sort: Sort.popular.v);

    if (res != null) {
      albums = res['data'];
      if (mounted) setState(() {});
    }
  }

  int page = 0;
  double angle = pi / 8;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) async {
      load();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      color: AppColor.blackL2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _header(),

            _recode(context),

            Row(
              spacing: 8,
              mainAxisAlignment: .center,
              children: .generate(albums.length, (index) {
                final act = page == index;

                return AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  decoration: BoxDecoration(
                    color: act ? AppColor.yellow : Colors.white10,
                    borderRadius: .circular(99),
                  ),

                  height: 8,
                  width: act ? 20 : 8,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Padding _recode(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _controller.isAnimating ? 380 : 300,
        curve: Curves.easeInOutCubic,
        child: PageView(
          onPageChanged: (value) {
            setState(() {
              page = value;
              _controller.stop();
              angle = pi / 8;
            });
          },
          children: albums.map((e) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        angle = (angle - details.delta.dy * .01).clamp(
                          -pi / 8,
                          pi / 8,
                        );
                      });
                    },
                    onVerticalDragEnd: (details) {
                      setState(() {
                        if (angle < pi / 16) {
                          _controller.repeat();
                        } else {
                          _controller.stop();
                        }
                      });
                    },
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/turntable.png',
                            width: 300,
                            fit: .cover,
                          ),
                        ),

                        Positioned.fill(
                          child: Align(
                            alignment: Alignment(-.1, -.1),
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, _) {
                                return Transform.rotate(
                                  angle: _controller.value * pi * 2,
                                  child: Container(
                                    width: 210,
                                    height: 210,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/vinyl.png'),
                                        fit: .cover,
                                      ),
                                    ),
                                    alignment: .center,
                                    child: CircleAvatar(
                                      radius: 42,
                                      backgroundImage: NetworkImage(
                                        e.albumImage,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        Positioned.fill(
                          child: Align(
                            alignment: Alignment(.7, -.9),
                            child: Transform.rotate(
                              angle: angle,
                              alignment: Alignment(.6, 0),
                              child: Image.asset(
                                'assets/tonearm.png',
                                fit: .cover,
                                width: 180,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: _controller.isAnimating ? 1 : .2,
                    curve: Curves.easeInOutCubic,
                    child: Material(
                      clipBehavior: .hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(12),
                      ),
                      color: AppColor.blackL2,
                      child: InkWell(
                        onTap: () {
                          context.go(AlbumScreen(id: e.id));
                        },
                        child: Row(
                          spacing: 12,
                          children: [
                            AnimatedSlide(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOutCubic,
                              offset: _controller.isAnimating
                                  ? .zero
                                  : .new(0, -.8),
                              child: ClipRRect(
                                borderRadius: .circular(12),
                                child: Image.network(
                                  e.albumImage,
                                  fit: .cover,
                                  width: 64,
                                  height: 64,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                spacing: 4,
                                children: [
                                  AppTextStyle.bold15().text(
                                    e.albumName,
                                    overflow: .ellipsis,
                                  ),
                                  AppTextStyle.bold14(color: AppColor.yellow)
                                      .text(e.artist, overflow: .ellipsis),
                                  AppTextStyle.bold12(color: AppColor.whiteL3)
                                      .text(
                                        '${e.genre.l} • ${e.condition}',
                                        overflow: .ellipsis,
                                      ),
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
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Column _header() {
    return Column(
      spacing: 4,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.blackL2,
            foregroundColor: AppColor.yellow,
            minimumSize: .zero,
            padding: .symmetric(vertical: 8, horizontal: 16),
            side: BorderSide(color: AppColor.yellow),
          ),
          onPressed: () {},
          child: AppTextStyle.bold12(color: null).text('오늘의 추천 바이닐'),
        ),

        AppTextStyle.bold24().text('오늘, 이 바이닐은\n어떠세요?', align: .center),
        AppTextStyle.regular12().text('매일 새롭게 선별한 특별한 한 장', align: .center),
      ],
    );
  }
}
