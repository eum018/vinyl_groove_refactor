import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove/core/theme/app_color.dart';
import 'package:vinyl_groove/core/theme/app_text_style.dart';
import 'package:vinyl_groove/main.dart';
import 'package:vinyl_groove/models/album_model.dart';
import 'package:vinyl_groove/feature/album/widgets/like_button.dart';

import '../presentation/album_screen.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({super.key, required this.album, this.size = 13});

  final AlbumModel album;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: .antiAlias,
      color: AppColor.blackL3,
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      child: InkWell(
        onTap: () {
          context.go(AlbumScreen(id: album.id));
        },
        child: SizedBox(
          width: 140,
          height: 210,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              SizedBox(
                height: 120,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        album.albumImage,
                        fit: .cover,
                        errorBuilder: (context, error, stackTrace) =>
                            SizedBox(),
                      ),
                    ),

                    Align(
                      alignment: .topRight,
                      child: LikeButton(albumModel: album),
                    ),
                    Align(
                      alignment: .bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(180),
                            borderRadius: .circular(4),
                          ),
                          padding: .symmetric(vertical: 4, horizontal: 8),
                          child: AppTextStyle.medium10().text(album.condition),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 4,
                  children: [
                    Text(
                      album.albumName,
                      overflow: .ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: .bold,
                        fontSize: size,
                      ),
                    ),
                    Text(
                      album.artist,
                      overflow: .ellipsis,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: size - 1,
                      ),
                    ),
                    Text(
                      NumberFormat('₩ #,###').format(album.price),
                      style: TextStyle(
                        color: AppColor.yellow,
                        fontWeight: .bold,
                        fontSize: size,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
