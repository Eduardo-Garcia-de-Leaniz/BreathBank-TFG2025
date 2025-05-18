import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/app_button.dart';

void main() {
  testWidgets('AppButton muestra el texto y responde al tap', (
    WidgetTester tester,
  ) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(text: 'Presionar', onPressed: () => tapped = true),
        ),
      ),
    );

    expect(find.text('Presionar'), findsOneWidget);
    await tester.tap(find.text('Presionar'));
    expect(tapped, isTrue);
  });
}
