import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/investment_slider.dart';

void main() {
  testWidgets('InvestmentSlider muestra valores y permite cambiar el slider', (
    WidgetTester tester,
  ) async {
    double sliderValue = 5;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return InvestmentSlider(
                sliderValue: sliderValue,
                rangoInferior: 1,
                rangoSuperior: 10,
                onChanged: (value) => setState(() => sliderValue = value),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Listón de Inversión: 5'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);

    await tester.drag(find.byType(Slider), const Offset(100, 0));
    await tester.pump();

    expect(find.textContaining('Listón de Inversión:'), findsOneWidget);
  });
}
