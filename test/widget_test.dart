import 'package:flutter_test/flutter_test.dart';
import 'package:adhkari/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AdhkariApp());
    await tester.pumpAndSettle();

    expect(find.text('أذكاري'), findsWidgets);
  });
}
