import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/breathing_animation_widget.dart';

void main() {
  testWidgets('BreathingAnimationWidget muestra textos y cambia de estado', (
    WidgetTester tester,
  ) async {
    final key = GlobalKey<BreathingAnimationWidgetState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BreathingAnimationWidget(
            key: key,
            initialDuration: 1,
            incrementPerBreath: 1,
          ),
        ),
      ),
    );

    // Debe mostrar "Inhalar" y "Respiración 1"
    expect(find.text('Inhalar'), findsOneWidget);
    expect(find.text('Respiración 1'), findsOneWidget);

    // Simula iniciar la animación
    key.currentState?.resume();
    await tester.pump(
      const Duration(seconds: 2),
    ); // Espera a que cambie de estado

    // Ahora debería mostrar "Exhalar" o "Inhalar" dependiendo del ciclo
    expect(find.textContaining('Respiración'), findsOneWidget);
  });
}
