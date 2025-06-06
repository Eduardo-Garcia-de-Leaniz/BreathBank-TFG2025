import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/arrow_previous_symbol.dart';

void main() {
  testWidgets('ArrowPreviousSymbol muestra el icono de flecha atrás', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: Stack(children: const [ArrowPreviousSymbol()])),
    );

    // Busca el icono de flecha atrás
    expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
  });
}
