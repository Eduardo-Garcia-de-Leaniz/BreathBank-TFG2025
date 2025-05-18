import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/stat_card_widget.dart';

void main() {
  testWidgets('StatCardWidget muestra el icono, título y valor', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatCardWidget(
            title: 'Test',
            value: '123',
            icon: Icons.star,
            color: Colors.blue,
          ),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
    expect(find.text('123'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });
}
