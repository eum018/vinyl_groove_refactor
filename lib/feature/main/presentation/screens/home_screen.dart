import 'package:flutter/material.dart';
import 'package:vinyl_groove/app_ctrl.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';
import 'package:vinyl_groove/core/theme/app_input_style.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';
import 'package:vinyl_groove/core/widget/app_input_field.dart';
import 'package:vinyl_groove/core/widget/base_scaffold.dart';
import 'package:vinyl_groove/models/album_model.dart';
import 'package:vinyl_groove/feature/album/widgets/album_card.dart';
import 'package:vinyl_groove/feature/main/presentation/widgets/main_appbar.dart';
import 'package:vinyl_groove/feature/main/presentation/widgets/barcode_button.dart';
import 'package:vinyl_groove/feature/main/presentation/widgets/recode_widget.dart';

import '../../../../core/enum/genre.dart';
import '../../../../core/enum/sort.dart';
import '../../../../main.dart';
import '../../../nav_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Sort sort = .popular;

  late final TabController tabController;

  List<AlbumModel> albums = [];

  Future<void> load() async {
    final res = await appCtrl.loadAlbums(limit: 10, sort: sort.v);

    if (res != null) {
      albums = res['data'];
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      load();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget wholeViewButton({VoidCallback? onTap}) => TextButton(
      onPressed: () {
        appCtrl.page.value = 1;
      },
      child: Row(
        mainAxisSize: .min,
        spacing: 4,
        children: [
          AppTextStyle.medium14(color: AppColor.whiteL1).text('전체 보기'),
          Icon(Icons.arrow_forward_ios, color: Colors.white60, size: 12),
        ],
      ),
    );

    return SafeArea(
      child: BaseScaffold(
        appBar: MainAppbar(),
        body: RefreshIndicator(
          onRefresh: () async {
            context.re(NavScreen());
            load();
          },
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 16,
                  children: [
                    AppInputField(
                      onTap: () {
                        appCtrl.page.value = 1;
                      },
                      decoration: AppInputStyle.base(
                        hint: '앨범명, 아티스트 검색',
                        prefIcon: .search,
                        suf: BarcodeButton(),
                      ),
                    ),

                    RecodeWidget(),

                    Row(
                      children: [
                        Expanded(child: AppTextStyle.bold18().text('장르별 둘러보기')),
                        wholeViewButton(
                          onTap: () {
                            appCtrl.page.value = 1;
                          },
                        ),
                      ],
                    ),

                    _genreGrid(),

                    Row(
                      children: [
                        Expanded(child: _tabBar()),

                        wholeViewButton(),
                      ],
                    ),
                  ],
                ),
              ),

              _albumList(),
            ],
          ),
        ),
      ),
    );
  }

  TabBar _tabBar() {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      indicatorColor: AppColor.yellow,
      dividerHeight: 0,
      tabAlignment: .start,
      labelColor: Colors.white,
      padding: .zero,
      labelPadding: .symmetric(horizontal: 8),
      unselectedLabelColor: Colors.white60,
      onTap: (value) {
        setState(() {
          sort = Sort.values[value];
        });
        load();
      },
      tabs: Sort.values.map((e) => Tab(text: e.l)).toList(),
    );
  }

  SizedBox _albumList() {
    return SizedBox(
      height: 260,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: ListView.separated(
          scrollDirection: .horizontal,
          padding: .symmetric(horizontal: 16),
          itemCount: albums.length,
          itemBuilder: (context, index) => AlbumCard(album: albums[index]),
          separatorBuilder: (context, index) => SizedBox(width: 12),
        ),
      ),
    );
  }

  GridView _genreGrid() {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        mainAxisExtent: 68,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),

      children: Genre.values
          .map(
            (e) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: .circular(8),
                side: BorderSide(color: Colors.white10),
              ),
              color: AppColor.blackL1,
              child: InkWell(
                onTap: () {
                  appCtrl.gen = e;
                  appCtrl.page.value = 1;
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    spacing: 4,
                    children: [
                      e.i.icon(color: AppColor.yellow, size: 28),
                      AppTextStyle.regular12().text(e == .ETC ? '기타' : e.l),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
