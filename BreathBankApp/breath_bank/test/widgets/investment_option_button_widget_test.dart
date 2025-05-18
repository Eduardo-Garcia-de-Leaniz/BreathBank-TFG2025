import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/investment_option_button.dart';

void main() {
  testWidgets('InvestmentOptionButton muestra el label y responde al tap', (
    WidgetTester tester,
  ) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InvestmentOptionButton(
            label: 'Opción 1',
            isSelected: true,
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Opción 1'), findsOneWidget);

    await tester.tap(find.text('Opción 1'));
    expect(tapped, isTrue);
  });
}
