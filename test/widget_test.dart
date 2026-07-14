// File: test/widget_test.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculator_app/main.dart';

void main() {
  testWidgets('Calculator smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: CalculatorApp(),
      ),
    );

    // Verify that our calculator starts showing '0'.
    expect(find.text('0'), findsWidgets);
  });
}
