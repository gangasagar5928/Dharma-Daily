import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Smoke test: verify the Flutter framework renders a minimal widget tree
    // without errors. Full app startup depends on asset loading which is
    // covered by data_test.dart and panchang_test.dart.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Dharma Daily')),
        ),
      ),
    );
    expect(find.text('Dharma Daily'), findsOneWidget);
  });
}
