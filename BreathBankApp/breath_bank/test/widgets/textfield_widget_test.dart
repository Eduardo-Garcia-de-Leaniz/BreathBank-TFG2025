import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/textfield.dart';

void main() {
  testWidgets('TextFieldForm muestra label, hint y permite escribir', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TextFieldForm(
            controller: controller,
            label: 'Nombre',
            hintText: 'Introduce tu nombre',
            icon: Icons.person,
          ),
        ),
      ),
    );

    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Introduce tu nombre'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Juan');
    expect(controller.text, 'Juan');
  });
}
