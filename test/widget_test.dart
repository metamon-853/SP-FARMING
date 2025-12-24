import 'package:flutter_test/flutter_test.dart';

import 'package:sp_farming/main.dart';

void main() {
  testWidgets('App starts with login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that login screen is displayed
    expect(find.text('SP-FARMING'), findsOneWidget);
    expect(find.text('芋づくり製作ゲーム'), findsOneWidget);
    expect(find.text('ログイン'), findsOneWidget);
  });
}
