import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/arrow_next_symbol.dart';

void main() {
  testWidgets('ArrowNextSymbol muestra el icono de flecha adelante', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: Stack(children: const [ArrowNextSymbol()])),
    );

    // Busca el icono de flecha adelante
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
  });
}
