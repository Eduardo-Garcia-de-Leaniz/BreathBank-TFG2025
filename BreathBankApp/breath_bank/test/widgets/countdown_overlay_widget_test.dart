import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/countdown_overlay_widget.dart';

void main() {
  testWidgets('CountdownOverlayWidget muestra y elimina el overlay', (
    WidgetTester tester,
  ) async {
    bool completed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    CountdownOverlayWidget.show(
                      context: context,
                      initialCountdown: 1,
                      onCountdownComplete: () {
                        completed = true;
                      },
                    );
                  },
                  child: const Text('Mostrar overlay'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Mostrar overlay'));
    await tester.pump();

    expect(find.byType(Overlay), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));

    expect(completed, isTrue);
  });
}
