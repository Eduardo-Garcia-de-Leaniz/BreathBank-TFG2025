import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/info_card_widget.dart';

void main() {
  testWidgets('InfoCard muestra el título, valor y barra de progreso', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InfoCard(
            title: 'Pulsaciones',
            value: '80',
            numberColor: Colors.green,
            textColor: Colors.white,
            maxValue: 200,
            width: 220,
            height: 150,
          ),
        ),
      ),
    );

    expect(find.text('Pulsaciones'), findsOneWidget);
    expect(find.text('80'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('200'), findsOneWidget);
  });
}
