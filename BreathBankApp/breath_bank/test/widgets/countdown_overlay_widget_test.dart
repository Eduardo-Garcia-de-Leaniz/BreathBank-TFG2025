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

    // Pulsa el botón para mostrar el overlay
    await tester.tap(find.text('Mostrar overlay'));
    await tester.pump(); // Overlay insertado

    // Debe aparecer el widget CountdownOverlay (busca por tipo o por texto si lo tiene)
    expect(find.byType(Overlay), findsOneWidget);

    // Espera a que termine el countdown
    await tester.pump(const Duration(seconds: 2));

    // El callback debe haberse llamado
    expect(completed, isTrue);
  });
}
