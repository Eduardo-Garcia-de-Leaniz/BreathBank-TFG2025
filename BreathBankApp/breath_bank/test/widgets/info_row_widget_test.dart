import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/info_row_widget.dart';

void main() {
  testWidgets('InfoRowWidget muestra label y value correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: InfoRowWidget(label: 'Edad', value: '25')),
      ),
    );

    expect(find.text('Edad: '), findsOneWidget);
    expect(find.text('25'), findsOneWidget);
  });
}
