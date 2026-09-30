import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove/core/enum/condition.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';
import 'package:vinyl_groove/core/theme/app_input_style.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';
import 'package:vinyl_groove/core/widget/app_input_field.dart';
import 'package:vinyl_groove/core/widget/base_scaffold.dart';
import 'package:vinyl_groove/feature/album/widgets/album_card.dart';
import 'package:vinyl_groove/feature/main/presentation/widgets/filter_button.dart';
import 'package:vinyl_groove/feature/main/presentation/widgets/main_appbar.dart';

import '../../../../app_ctrl.dart';
import '../../../../core/enum/genre.dart';
import '../../../../core/enum/sort.dart';
import '../../../../core/enum/trade.dart';
import '../../../../models/album_model.dart';
import '../widgets/barcode_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Sort sort = .popular;

  final _controller = ScrollController();

  Set<Genre> gen = <Genre>{};
  Set<Condition> con = <Condition>{};
  String trd = '';
  RangeValues pri = RangeValues(1000, 1000000);

  bool hide = false;

  final sr = TextEditingController();

  int page = 1;
  int total = 0;
  bool hasNext = true;

  List<AlbumModel> albums = [];

  Future<void> load({refresh = true}) async {
    if (refresh) {
      page = 1;
    } else {
      page++;
    }

    final text = sr.text;

    final res = await appCtrl.loadAlbums(
      sort: sort.v,
      conditions: con
          .fold('', (previousValue, element) => '$previousValue,${element.v}')
          .replaceFirst(',', ''),
      genres: gen
          .fold('', (previousValue, element) => '$previousValue,${element.v}')
          .replaceFirst(',', ''),
      keyword: text,
      maxPrice: pri.end.toInt(),
      minPrice: pri.start.toInt(),
      page: page,
      size: 12,
      tradeMethod: trd,
    );

    if (res != null) {
      if (text != sr.text) return;

      if (refresh) {
        albums = res['data'];
      } else {
        albums.addAll(res['data']);
      }

      page = res['pagination']['page'];
      total = res['pagination']['totalCount'];
      hasNext = res['pagination']['hasNext'];

      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.position.hasPixels) {
        if (_controller.position.pixels >=
            _controller.position.maxScrollExtent) {
          if (hasNext) {
            load(refresh: false);
          }
        }
      }
    });
    if (appCtrl.gen != null) {
      gen = {appCtrl.gen!};
      appCtrl.gen = null;
    }

    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) async {
      load();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: MainAppbar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 16,
              children: [
                AppInputField(
                  controller: sr,
                  onChanged: (value) {
                    setState(() {});
                    load();
                  },
                  decoration: AppInputStyle.base(
                    hint: '앨범명, 아티스트',
                    suf: sr.text.isNotEmpty
                        ? IconButton(
                            style: IconButton.styleFrom(),
                            onPressed: () {
                              setState(() {
                                sr.clear();
                              });
                              load();
                            },
                            icon: Icon(Icons.close, color: Colors.white),
                          )
                        : BarcodeButton(),
                  ),
                ),

                _filter(),
              ],
            ),
          ),

          Divider(color: AppColor.blackL1, height: 1),
          Divider(color: AppColor.blackL2, height: 1),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 24,
                children: [
                  Row(
                    children: [
                      AppTextStyle.bold18().text('검색 결과 $total개'),

                      Spacer(),

                      _sortPopupButton(),
                    ],
                  ),

                  Expanded(child: _albumGrid()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  GridView _albumGrid() {
    return GridView.builder(
      controller: _controller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 210,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      shrinkWrap: true,
      itemBuilder: (context, index) =>
          AlbumCard(album: albums[index], size: 11, key: Key('$index')),
      itemCount: albums.length,
    );
  }

  PopupMenuButton<dynamic> _sortPopupButton() {
    return PopupMenuButton(
      color: AppColor.blackL2,
      itemBuilder: (context) => <Sort>[.recent, .popular, .price_asc]
          .map(
            (e) => PopupMenuItem(
              onTap: () {
                setState(() {
                  sort = e;
                });

                load();
              },
              child: AppTextStyle.regular14(color: AppColor.whiteL1)
                  .text(e == .price_asc ? '최저 가격순' : '${e.l}순'),
            ),
          )
          .toList(),
      child: Row(
        mainAxisSize: .min,
        children: [
          AppTextStyle.medium12(color: AppColor.whiteL1)
              .text(sort == .price_asc ? '최저 가격순' : '${sort.l}순'),
          Icon(Icons.arrow_drop_down, color: Colors.white60, size: 24),
        ],
      ),
    );
  }

  Column _filter() {
    Widget _filterLine<T>({
      required String label,
      Widget? pref,
      List<Widget>? items,
      Widget? child,
    }) => Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ),

        if (child != null)
          child
        else
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: .horizontal,
              child: Row(spacing: 6, children: [?pref, ...?items]),
            ),
          ),
      ],
    );

    return Column(
      children: [
        Row(
          spacing: 12,
          children: [
            Icon(Icons.tune, color: Colors.white60, size: 18),

            AppTextStyle.medium15().text('필터'),

            Spacer(),

            TextButton(
              style: TextButton.styleFrom(minimumSize: .zero, padding: .zero),
              onPressed: () {
                setState(() {
                  gen.clear();
                  con.clear();
                  trd = '';
                  pri = RangeValues(1000, 1000000);
                });

                load();
              },
              child: AppTextStyle.medium14(color: AppColor.yellow)
                  .text('필터 초기화'),
            ),
          ],
        ),

        if (!hide)
          Column(
            children: [
              /// 장르
              _filterLine(
                label: '장르',
                pref: FilterButton(
                  selected: gen.isEmpty,
                  onPressed: () {
                    setState(() {
                      gen.clear();
                    });
                    load();
                  },
                  label: '잔체',
                ),
                items: Genre.values.map((e) {
                  final act = gen.contains(e);
                  return FilterButton(
                    selected: act,
                    onPressed: () {
                      setState(() {
                        if (!act) {
                          gen.add(e);
                        }
                      });
                      load();
                    },
                    label: e.l,
                  );
                }).toList(),
              ),

              /// 음반상태
              _filterLine(
                label: '음반 상태',
                pref: FilterButton(
                  selected: con.isEmpty,
                  onPressed: () {
                    setState(() {
                      con.clear();
                    });
                    load();
                  },
                  label: '잔체',
                ),
                items: Condition.getFilterList().map((e) {
                  final act = con.contains(e);
                  return FilterButton(
                    selected: act,
                    onPressed: () {
                      setState(() {
                        if (!act) {
                          con.add(e);
                        }
                      });
                    },
                    label: Condition.getFilterLabel(e),
                  );
                }).toList(),
              ),

              _filterLine(
                label: '가격 범위',
                child: Expanded(
                  child: Row(
                    spacing: 6,
                    children: [
                      FilterButton(
                        selected: false,
                        onPressed: null,
                        label: NumberFormat('₩#,###').format(pri.start),
                      ),

                      Expanded(
                        child: RangeSlider(
                          min: 1000,
                          max: 1000000,
                          activeColor: AppColor.yellow,
                          padding: .zero,
                          values: pri,
                          onChanged: (value) {
                            setState(() {
                              pri = value;
                            });
                          },
                          onChangeEnd: (value) {
                            load();
                          },
                        ),
                      ),

                      FilterButton(
                        selected: false,
                        onPressed: null,
                        label: pri.end == 1000000
                            ? '₩1,000,000+'
                            : NumberFormat('₩#,###').format(pri.end),
                      ),
                    ],
                  ),
                ),
              ),

              _filterLine(
                label: '거래 방식',
                pref: FilterButton(
                  selected: trd == '',
                  onPressed: () {
                    setState(() {
                      trd = '';
                    });
                    load();
                  },
                  label: '잔체',
                ),
                items: Trade.values.map((e) {
                  final act = trd == e.v;

                  return FilterButton(
                    selected: act,
                    onPressed: () {
                      setState(() {
                        trd = e.v;
                      });
                      load();
                    },
                    label: e.l,
                  );
                }).toList(),
              ),
            ],
          ),
        TextButton(
          onPressed: () {
            setState(() {
              hide = !hide;
            });
          },
          child: Row(
            mainAxisSize: .min,
            spacing: 4,
            children: [
              AppTextStyle.medium12(color: AppColor.whiteL1)
                  .text(hide ? '펼치기' : '접기'),
              Icon(
                hide ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                color: Colors.white60,
                size: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
