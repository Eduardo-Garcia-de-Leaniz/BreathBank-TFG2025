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

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text(testMessage), findsOneWidget);

      expect(find.byType(SnackBar), findsOneWidget);
    },
  );
}
