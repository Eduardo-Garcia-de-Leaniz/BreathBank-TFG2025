import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/countdown_widget.dart';

void main() {
  testWidgets('CountdownOverlay cuenta hacia atrás y llama a callback', (
    WidgetTester tester,
  ) async {
    bool completed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              CountdownOverlay(
                initialCountdown: 2,
                onCountdownComplete: () => completed = true,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('2'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('1'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(completed, isTrue);
  });
}
