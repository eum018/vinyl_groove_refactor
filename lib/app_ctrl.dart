import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:vinyl_groove/main.dart';
import 'package:vinyl_groove/models/album_model.dart';

import 'core/enum/genre.dart';

const keyL = 'keyL';

final appCtrl = AppCtrl();

class AppCtrl {
  final ticker = ValueNotifier(0);
  final ticker2 = ValueNotifier(0);
  final page = ValueNotifier(0);

  String? tkn;
  Map? user;
  Genre? gen;

  init() async {
    likes = (prefs.getStringList(keyL) ?? [])
        .map((e) => AlbumModel.from(jsonDecode(e)))
        .toList();
  }

  save() async {
    await prefs.setStringList(
      keyL,
      likes.map((e) => jsonEncode(e.toJson())).toList(),
    );
    ticker.value++;
  }

  List<AlbumModel> likes = [];

  Future<Map?> loadAlbums({
    sort,
    limit,
    keyword,
    genres,
    conditions,
    minPrice,
    maxPrice,
    tradeMethod,
    page,
    size,
  }) =>
      get(
        Uri.parse('http://${baseUrl}/products').replace(
          queryParameters: {
            'sort': sort?.toString(),
            'limit': limit?.toString(),
            'keyword': keyword?.toString(),
            'genres': genres?.toString(),
            'conditions': conditions?.toString(),
            'minPrice': minPrice?.toString(),
            'maxPrice': maxPrice?.toString(),
            'tradeMethod': tradeMethod?.toString(),
            'page': page?.toString(),
            'size': size?.toString(),
          }..removeWhere((key, value) => value == null),
        ),
        headers: baseHeader,
      ).then((value) async {
        if (value.statusCode == 429) {
          return null;
        }

        final body = jsonDecode(value.body);

        if (body['success'] ?? false) {
          body['data'] = (body['data'] as List)
              .map((e) => AlbumModel.from(e))
              .toList();

          return body;
        }

        message((body['errors'] as List?)?.firstOrNull['message']);
      }, onError: (e) => message('서버 통신 에러'));

  Map? alerts;

  Future<Map?> loadAlerts() =>
      get(
        Uri.parse('http://${baseUrl}/notifications'),
        headers: baseHeader,
      ).then((value) async {
        if (value.statusCode == 429) return null;

        final body = jsonDecode(value.body);
        if (body['success'] ?? false) {
          alerts = body['data'];

          ticker2.value++;
          return body;
        }

        message((body['errors'] as List?)?.firstOrNull['message']);
      }, onError: (e) => message('서버 통신 에러'));
}
