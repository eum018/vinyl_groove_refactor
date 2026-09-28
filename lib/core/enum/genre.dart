import '../../../../core/theme/app_icon.dart';

enum Genre {
  ROCK('ROCK', 'Rock', .rock),
  JAZZ('JAZZ', 'Jazz', .jazz),
  POP('POP', 'Pop', .pop),
  HIPHOP('HIPHOP', 'Hip-Hop', .hip),
  ELECTRONIC('ELECTRONIC', 'Electronic', .electronic),
  CLASSICAL('CLASSICAL', 'Classical', .classical),
  RNB_SOUL('RNB_SOUL', 'R&B/Soul', AppIcon.rnb),
  ETC('ETC', 'Etc', .etc);

  final String v;
  final String l;
  final AppIcon i;

  const Genre(this.v, this.l, this.i);

   static Genre? fromCode(String code) {
    return Genre.values.where((element) => element.v == code).firstOrNull;
  }
}
