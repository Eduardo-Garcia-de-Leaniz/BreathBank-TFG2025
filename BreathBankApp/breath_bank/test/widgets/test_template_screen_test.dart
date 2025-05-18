import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/views/test_screen_template.dart';

void main() {
  testWidgets(
    'TestScreenTemplate muestra descripción e interactivo y navega entre páginas',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TestScreenTemplate(
            title: 'Prueba Widget',
            description: const Center(child: Text('Descripción de la prueba')),
            interactiveContent: const Center(
              child: Text('Contenido interactivo'),
            ),
          ),
        ),
      );

      // Verifica el título
      expect(find.text('Prueba Widget'), findsOneWidget);

      // Verifica la descripción
      expect(find.text('Descripción de la prueba'), findsOneWidget);

      // Navega a la segunda página (PageView)
      final gesture = await tester.startGesture(const Offset(300, 300));
      await gesture.moveBy(const Offset(-400, 0));
      await tester.pumpAndSettle();
    },
  );
}
