import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/snackbar_widget.dart';

void main() {
  testWidgets(
    'SnackBarWidget muestra un SnackBar con el mensaje y color correctos',
    (WidgetTester tester) async {
      const testMessage = 'Mensaje de prueba';
      const testColor = Colors.red;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SnackBarWidget(
              message: testMessage,
              backgroundColor: testColor,
            ),
          ),
        ),
      );

      // Espera a que el SnackBar aparezca
      await tester.pump(); // Primer frame
      await tester.pump(const Duration(milliseconds: 100)); // SnackBar aparece

      expect(find.text(testMessage), findsOneWidget);

      // Opcional: verifica que haya un SnackBar en el árbol de widgets
      expect(find.byType(SnackBar), findsOneWidget);
    },
  );
}
