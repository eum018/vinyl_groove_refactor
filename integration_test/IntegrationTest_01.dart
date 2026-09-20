import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_groove/main.dart' as app;
import 'package:vinyl_groove/feature/album/widgets/album_card.dart';

void main() async {
  int index = 0;

  sec(m, Future Function() act, WidgetTester tester) async {
    print('[STEP No.${++index}] ${m}');

    await tester.pumpAndSettle();
    await tester.pumpAndSettle();

    await act();

    await tester.pumpAndSettle();
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 2));

    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
  }

  vis(Finder f, WidgetTester tester) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
  }

  testWidgets('test', (tester) async {
    await sec('애플리케이션 실행', () async {
      app.main();
      await Future.delayed(Duration(seconds: 2));
    }, tester);

    await sec('잘못된 이메일 형식으로 로그인 시도', () async {
      final f1 = find.byType(TextField).at(0);
      final f2 = find.byType(TextField).at(1);
      final f3 = find.byType(ElevatedButton).last;

      await vis(f1, tester);
      await tester.enterText(f1, 'invalid-email');
      await vis(f2, tester);
      await tester.enterText(f2, 'Test1234!');

      await vis(f3, tester);
      await tester.tap(f3);
    }, tester);

    await sec('입력 필드 초기화 후 짧은 비밀번호로 로그인 시도', () async {
      final f1 = find.byType(TextField).at(0);
      final f2 = find.byType(TextField).at(1);
      final f3 = find.byType(ElevatedButton).last;

      await vis(f1, tester);
      await tester.enterText(f1, 'test@example.com');
      await vis(f2, tester);
      await tester.enterText(f2, '123');

      await vis(f3, tester);
      await tester.tap(f3);
    }, tester);

    await sec('입력 필드 초기화 후 정상 값으로 로그인 시도', () async {
      final f1 = find.byType(TextField).at(0);
      final f2 = find.byType(TextField).at(1);
      final f3 = find.byType(ElevatedButton).last;

      await vis(f1, tester);
      await tester.enterText(f1, 'test@example.com');
      await vis(f2, tester);
      await tester.enterText(f2, 'Test1234!');

      await vis(f3, tester);
      await tester.tap(f3);
    }, tester);

    await sec('하단 네비게이션의 "마이페이지" 탭 클릭', () async {
      final f1 = find.text('마이페이지').last;

      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('PIN 번호 간편 로그인 버튼 클릭', () async {
      final f1 = find.text('PIN 번호 간편 로그인').last;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('PIN 번호 순차 선택(동일 숫자)', () async {
      final f1 = find.text('1').last;
      await vis(f1, tester);
      await tester.tap(f1);
      final f2 = find.text('1').last;
      await vis(f2, tester);
      await tester.tap(f2);
      final f3 = find.text('1').last;
      await vis(f3, tester);
      await tester.tap(f3);
      final f4 = find.text('1').last;
      await vis(f4, tester);
      await tester.tap(f4);
    }, tester);

    await sec('PIN 번호 순차 선택(정상 숫자)', () async {
      final f0 = find.byType(Card).last;

      await vis(f0, tester);
      await tester.tap(f0);
      await vis(f0, tester);
      await tester.tap(f0);
      await vis(f0, tester);
      await tester.tap(f0);
      await vis(f0, tester);
      await tester.tap(f0);

      final f1 = find.text('0').last;
      await vis(f1, tester);
      await tester.tap(f1);
      final f2 = find.text('8').last;
      await vis(f2, tester);
      await tester.tap(f2);
      final f3 = find.text('2').last;
      await vis(f3, tester);
      await tester.tap(f3);
      final f4 = find.text('6').last;
      await vis(f4, tester);
      await tester.tap(f4);
    }, tester);

    await sec('PIN 번호 순차 선택(재확인 실패 숫자)', () async {
      final f1 = find.text('1').last;
      await vis(f1, tester);
      await tester.tap(f1);
      final f2 = find.text('2').last;
      await vis(f2, tester);
      await tester.tap(f2);
      final f3 = find.text('3').last;
      await vis(f3, tester);
      await tester.tap(f3);
      final f4 = find.text('4').last;
      await vis(f4, tester);
      await tester.tap(f4);
    }, tester);

    await sec('PIN 번호 순차 선택(재확인 정상 숫자)', () async {
      final f1 = find.text('0').last;
      await vis(f1, tester);
      await tester.tap(f1);
      final f2 = find.text('8').last;
      await vis(f2, tester);
      await tester.tap(f2);
      final f3 = find.text('2').last;
      await vis(f3, tester);
      await tester.tap(f3);
      final f4 = find.text('6').last;
      await vis(f4, tester);
      await tester.tap(f4);
    }, tester);

    await sec('PIN 번호 순차 선택(간편 로그인 실패 숫자)', () async {
      final f1 = find.text('1').last;
      await vis(f1, tester);
      await tester.tap(f1);
      final f2 = find.text('2').last;
      await vis(f2, tester);
      await tester.tap(f2);
      final f3 = find.text('3').last;
      await vis(f3, tester);
      await tester.tap(f3);
      final f4 = find.text('4').last;
      await vis(f4, tester);
      await tester.tap(f4);
    }, tester);

    await sec('PIN 번호 순차 선택(간편 로그인 성공 숫자)', () async {
      final f1 = find.text('0').last;
      await vis(f1, tester);
      await tester.tap(f1);
      final f2 = find.text('8').last;
      await vis(f2, tester);
      await tester.tap(f2);
      final f3 = find.text('2').last;
      await vis(f3, tester);
      await tester.tap(f3);
      final f4 = find.text('6').last;
      await vis(f4, tester);
      await tester.tap(f4);
    }, tester);

    await sec('하단 네비게이션의 "탐색" 탭 클릭', () async {
      final f1 = find.text('탐색').last;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('장르 필터 순차 클릭', () async {
      final f1 = find.text('Rock').first;
      await vis(f1, tester);
      await tester.tap(f1);

      final f2 = find.text('Jazz').first;
      await vis(f2, tester);
      await tester.tap(f2);
    }, tester);

    await sec('음반 상태 필터 순차 클릭', () async {
      final f1 = find.text('NM').first;
      await vis(f1, tester);
      await tester.tap(f1);

      final f2 = find.text('VG+').first;
      await vis(f2, tester);
      await tester.tap(f2);
    }, tester);

    await sec('"접기" 버튼 클릭', () async {
      final f1 = find.text('접기').first;
      await vis(f1, tester);
      await tester.tap(f1);
    }, tester);

    await sec('정렬 드롭다운 선택', () async {
      final f1 = find
          .byWidgetPredicate((element) => element is PopupMenuButton)
          .first;

      await vis(f1, tester);
      await tester.tap(f1);

      await tester.pumpAndSettle();

      final f2 = find.text('인기 매물순').first;
      await vis(f2, tester);
      await tester.tap(f2);
    }, tester);

    await sec('아래로 스크롤하여 15번째 상품 아이템까지 이동', () async {
      final f1 = find.byKey(Key('14'));

      final scroll = find.byType(GridView).first;

      await () async {
        while (f1.evaluate().isEmpty) {
          await tester.drag(scroll, .new(0, -100));

          await Future.delayed(Duration(seconds: 1));

          await tester.pumpAndSettle();
        }
      }().timeout(Duration(seconds: 10), onTimeout: () {});
    }, tester);
  });
}
