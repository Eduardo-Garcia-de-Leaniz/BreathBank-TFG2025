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

    // Debe mostrar "Inspira"
    expect(find.text('Inspira'), findsOneWidget);

    // Simula iniciar la animación
    key.currentState?.resume();
    await tester.pump(
      const Duration(seconds: 2),
    ); // Espera a que cambie de estado

    // Ahora debería mostrar "Exhalar" o "Inhalar" dependiendo del ciclo
    expect(find.textContaining('respiracion'), findsOneWidget);
  });

  testWidgets('BreathingAnimationWidget pausa y reanuda correctamente', (
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

    // Inicia la animación
    key.currentState?.resume();
    await tester.pump(const Duration(milliseconds: 500));
    key.currentState?.pause();
    final breathCountAfterPause = key.currentState?.getCurrentBreathCount();

    // Espera más tiempo, el contador no debe aumentar
    await tester.pump(const Duration(seconds: 2));
    expect(key.currentState?.getCurrentBreathCount(), breathCountAfterPause);
  });

  testWidgets('BreathingAnimationWidget resetea correctamente', (
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

    key.currentState?.resume();
    await tester.pump(const Duration(seconds: 2));
    key.currentState?.reset();
    await tester.pump();

    // Después de reset, debe mostrar "Inspira" y contador en 1
    expect(find.text('Inspira'), findsOneWidget);
    expect(find.textContaining('1 respiracion'), findsOneWidget);
  });
}
