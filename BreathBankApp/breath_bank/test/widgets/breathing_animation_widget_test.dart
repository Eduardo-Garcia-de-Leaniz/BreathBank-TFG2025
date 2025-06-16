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

    expect(find.text('Inspira'), findsOneWidget);

    key.currentState?.resume();
    await tester.pump(const Duration(seconds: 2));

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

    key.currentState?.resume();
    await tester.pump(const Duration(milliseconds: 500));
    key.currentState?.pause();
    final breathCountAfterPause = key.currentState?.getCurrentBreathCount();

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

    expect(find.text('Inspira'), findsOneWidget);
    expect(find.textContaining('0 respiraciones'), findsOneWidget);
  });
}
