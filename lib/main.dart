import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinyl_groove/app_ctrl.dart';

import 'feature/auth/presentation/screens/login_screen.dart';

void main() async {
  appCtrl.ticker;

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([.portraitDown, .portraitUp]);

  prefs = await SharedPreferences.getInstance();

  appCtrl.init();

  cameras = await availableCameras();

  runApp(MaterialApp(home: LoginScreen()));
}

Future<dynamic> message(m, {g = false}) => channelM.invokeMethod('t', {
  'm': g ? '${m} 기능은 중비중입니다.\n다음에 다시 시도해 주세요.' : m ?? 'error',
});

final channelM = MethodChannel('com.example.vinyl_groove_m');

late final SharedPreferences prefs;

List<CameraDescription> cameras = [];

const baseUrl = '192.168.100.200:5003';

Map<String, String> get baseHeader => {
  'Content-Type': 'application/json',
  if (appCtrl.tkn != null) 'Authorization': 'Bearer ${appCtrl.tkn}',
};

extension QB on BuildContext {
  Future<dynamic> go(Widget page) =>
      Navigator.push(this, MaterialPageRoute(builder: (context) => page));

  Future<dynamic> re(Widget page) => Navigator.pushReplacement(
    this,
    MaterialPageRoute(builder: (context) => page),
  );

  void back([r]) => Navigator.pop(this, r);
}

enum AppIcon {
  edit('edit.svg'),
  finger('finger-print.svg'),
  help('help.svg'),
  history('history.svg'),
  info('info.svg'),
  inventory('inventory.svg'),
  pin('pin-number-pad.svg'),
  shopping('shopping-bag.svg'),
  delete('delete.svg'),
  add('add.svg'),
  album('album.svg'),
  barcode('barcode-scan.svg'),
  chevron('chevron-right.svg'),
  classical('classical.svg'),
  electronic('electronic.svg'),
  email('email.svg'),
  etc('etc.svg'),
  heart('heart.svg'),
  hip('hip-hop.svg'),
  home('home.svg'),
  jazz('jazz.svg'),
  lock('lock.svg'),
  mypage('mypage.svg'),
  notification('notification.svg'),
  person('person.svg'),
  pop('pop.svg'),
  rnb('rnb-soul.svg'),
  rock('rock.svg'),
  search('search.svg'),
  visibility('visibility.svg'),
  visibilityoff('visibility-off.svg');

  final String p;

  const new(this.p);

  SvgPicture icon({Color? color, double? size}) => SvgPicture.asset(
    'assets/icons/$p',
    width: size,
    height: size,
    color: color,
  );
}
