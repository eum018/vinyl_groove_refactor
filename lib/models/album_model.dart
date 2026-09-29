import 'package:vinyl_groove/core/enum/condition.dart';

import '../core/enum/genre.dart';
import '../core/enum/trade.dart';

class AlbumModel {
  final int id;
  final String albumName;
  final String artist;
  final Genre genre;
  final Condition condition;
  final int price;
  final Trade tradeMethod;
  final String albumImage;
  final int likeCount;
  final String createdAt;

  AlbumModel({
    required this.id,
    required this.albumName,
    required this.artist,
    required this.genre,
    required this.condition,
    required this.price,
    required this.tradeMethod,
    required this.albumImage,
    required this.likeCount,
    required this.createdAt,
  });

  factory AlbumModel.from(j) => AlbumModel(
    id: j['id'] ?? '',
    albumName: j['albumName'] ?? '',
    artist: j['artist'] ?? '',
    genre: Genre.fromCode(j['genre']) ?? .ETC,
    condition: Condition.fromCode(j['condition']) ?? .M,
    price: j['price'] ?? 0,
    tradeMethod: Trade.fromCode(j['tradeMethod']) ?? .BOTH,
    albumImage: j['albumImage'] ?? '',
    likeCount: j['likeCount'] ?? 0,
    createdAt: j['createdAt'] ?? '',
  );

  Map<String, Object> toJson() => {
    'id': id,
    'albumName': albumName,
    'artist': artist,
    'genre': genre.v,
    'condition': condition,
    'price': price,
    'tradeMethod': tradeMethod.v,
    'albumImage': albumImage,
    'likeCount': likeCount,
    'createdAt': createdAt,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/*
{
"success": true,
"data": [
{
"id": 1,
"albumName": "Blonde",
"artist": "Frank Ocean",
"genre": "RNB_SOUL",
"condition": "M",
"price": 95000,
"tradeMethod": "DIRECT",
"albumImage": "https://api.vinylgroove.com/images/album/blonde.jpg",
"likeCount": 320,
"createdAt": "2026-05-20T10:00:00Z"
}
],
"pagination": { "page": 1, "size": 12, "totalCount": 50, "totalPages": 5, "hasNext": true }
}*/
