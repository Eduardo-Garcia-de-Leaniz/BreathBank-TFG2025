import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/investment_slider.dart';

void main() {
  testWidgets('InvestmentSlider muestra valores y responde al cambio', (
    WidgetTester tester,
  ) async {
    double sliderValue = 5;
    double? changedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InvestmentSlider(
            sliderValue: sliderValue,
            rangoInferior: 1,
            rangoSuperior: 10,
            onChanged: (value) {
              changedValue = value;
            },
          ),
        ),
      ),
    );

    expect(find.text('Listón de Inversión: 5'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);

    final sliderFinder = find.byType(Slider);
    expect(sliderFinder, findsOneWidget);

    await tester.drag(sliderFinder, const Offset(200, 0));
    await tester.pumpAndSettle();

    expect(changedValue, isNotNull);
  });
}
