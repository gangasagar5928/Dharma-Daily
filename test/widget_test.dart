import 'package:flutter_test/flutter_test.dart';
import 'package:dharma_daily/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DharmaDailyApp());
    expect(find.byType(DharmaDailyApp), findsOneWidget);
  });
}
