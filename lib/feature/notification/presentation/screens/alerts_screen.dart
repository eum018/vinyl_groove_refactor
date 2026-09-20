import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove/app_ctrl.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';
import 'package:vinyl_groove/core/widget/app_appbar.dart';
import 'package:vinyl_groove/core/widget/app_confirm_dialog.dart';
import 'package:vinyl_groove/core/widget/base_scaffold.dart';
import 'package:vinyl_groove/core/widget/no_result_icon.dart';

import '../../../../main.dart';
import '../../../album/presentation/album_screen.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  Future<dynamic> read({int? id, bool? all}) async =>
      put(
        Uri.parse('http://${baseUrl}/notifications/read').replace(
          queryParameters: {'id': id?.toString(), 'all': all?.toString()}
            ..removeWhere((key, value) => value == null),
        ),
        headers: baseHeader,
      ).then((value) async {
        if (value.statusCode == 429) return null;

        final body = jsonDecode(value.body);
        if (body['success'] ?? false) {
          message(body['message']);
          appCtrl.loadAlerts();
          return body;
        }

        message((body['errors'] as List?)?.firstOrNull['message']);
      }, onError: (e) => message('서버 통신 에러'));

  Future<dynamic> remove() =>
      delete(
        Uri.parse('http://${baseUrl}/notifications'),
        headers: baseHeader,
      ).then((value) async {
        if (value.statusCode == 200) {
          final body = jsonDecode(value.body);
          if (body['success'] ?? false) {
            message(body['message']);
            appCtrl.loadAlerts();
            return body;
          }

          message((body['errors'] as List?)?.firstOrNull['message']);
        }
      }, onError: (e) => message('서버 통신 에러'));

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appCtrl.ticker2,
      builder: (context, _, child) {
        final List alerts = appCtrl.alerts?['notifications'] ?? [];

        return SafeArea(
          child: BaseScaffold(
            appBar: AppAppbar(
              title: '알림',
              actions: [if (alerts.isNotEmpty) _optionPopupButton()],
            ),
            body: RefreshIndicator(
              onRefresh: appCtrl.loadAlerts,
              child: alerts.isEmpty
                  ? LayoutBuilder(
                      builder: (context, constraints) => ListView(
                        children: [
                          SizedBox(
                            height: constraints.maxHeight,
                            child: Center(
                              child: NoResultIcon(
                                icon: .notification,
                                title: '알림이 없습니다.',
                                subTitle: '관심 상품의 가격이 변경되면 알려드릴게요.',
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: alerts.map((e) {
                        final down = e['title'] == '가격 인하';
                        final isRead = e['isRead'];

                        return _notificationTile(isRead, e, context, down);
                      }).toList(),
                    ),
            ),
          ),
        );
      },
    );
  }

  Material _notificationTile(isRead, e, BuildContext context, bool down) {
    return Material(
      clipBehavior: .hardEdge,
      color: isRead ? AppColor.background : AppColor.yellow.withAlpha(12),
      child: InkWell(
        onTap: () {
          read(id: e['id']);
          context.go(AlbumScreen(id: e['productId']));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: .start,
            spacing: 12,
            children: [
              ClipRRect(
                borderRadius: .circular(12),
                child: Image.network(
                  e['albumImage'],
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
                    Row(
                      spacing: 8,
                      children: [
                        Icon(
                          down ? Icons.arrow_downward : Icons.arrow_upward,
                          color: down ? Colors.green : Colors.red,
                          size: 18,
                        ),
                        AppTextStyle.medium14(
                          color: down ? Colors.green : Colors.red,
                        ).text(e['title'], overflow: .ellipsis),
                      ],
                    ),

                    Text(
                      e['albumName'],
                      overflow: .ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isRead ? .w400 : .bold,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        AppTextStyle.regular12(color: AppColor.whiteL1)
                            .copyWith(
                              decoration: .lineThrough,
                              decorationColor: Colors.white60,
                              decorationThickness: 1.5,
                            )
                            .text(
                              NumberFormat('₩ #,###')
                                  .format(e['previousPrice']),
                            ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white60,
                          size: 14,
                        ),
                        AppTextStyle.bold15().text(
                          NumberFormat('₩ #,###').format(e['currentPrice']),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Row(
                spacing: 8,
                children: [
                  AppTextStyle.regular12(color: AppColor.blackL3)
                      .text(_dateFormat(.parse(e['createdAt']))),
                  if (!isRead)
                    CircleAvatar(backgroundColor: AppColor.yellow, radius: 4),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuButton<dynamic> _optionPopupButton() {
    return PopupMenuButton(
      color: AppColor.blackL2,
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            read(all: true);
          },
          child: AppTextStyle.regular14().text('모두 읽음'),
        ),
        PopupMenuItem(
          onTap: () {
            AppConfirmDialog(
              title: '알림 전체 삭제',
              cancelAct: () {
                context.back();
              },
              confirmAct: () {
                context.back();
                remove();
              },
            ).show(context);
          },
          child: AppTextStyle.regular14(color: AppColor.red).text('전체 삭제'),
        ),
      ],
      padding: .symmetric(horizontal: 8),
      child: Icon(Icons.more_vert, color: Colors.white),
    );
  }
}

String _dateFormat(DateTime date) {
  final differ = DateTime.now().difference(date);

  if (differ.inDays >= 1) {
    return '${differ.inDays}일 전';
  }
  if (differ.inHours >= 1) {
    return '${differ.inHours}시간 전';
  }
  if (differ.inMinutes >= 1) {
    return '${differ.inMinutes}분 전';
  } else {
    return '방금 전';
  }
}
