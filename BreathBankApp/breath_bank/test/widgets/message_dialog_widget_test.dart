import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/message_dialog_widget.dart';

void main() {
  testWidgets('MessageDialog muestra título, mensaje y acciones', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder:
              (context) => ElevatedButton(
                onPressed: () {
                  showCustomMessageDialog(
                    context: context,
                    title: 'Título',
                    message: 'Mensaje de prueba',
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
                child: const Text('Abrir diálogo'),
              ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir diálogo'));
    await tester.pumpAndSettle();

    expect(find.text('Título'), findsOneWidget);
    expect(find.text('Mensaje de prueba'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);

    // Cierra el diálogo
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Título'), findsNothing);
  });
}
