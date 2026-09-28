import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinyl_groove/app_ctrl.dart';

import 'feature/auth/presentation/screens/login_screen.dart';

void main() async {
  appCtrl.ticker;

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([.portraitDown, .portraitUp]);

  prefs = await SharedPreferences.getInstance();

  appCtrl.init();

  try {
    cameras = await availableCameras();
  } catch (e) {}
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
