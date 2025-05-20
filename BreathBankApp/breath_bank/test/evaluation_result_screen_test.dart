import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/views/evaluation_result_screen.dart';

void main() {
  testWidgets(
    'EvaluationResultScreen muestra resultados y navega al dashboard',
    (WidgetTester tester) async {
      // Datos de prueba para los argumentos
      final args = {
        'nivelInversorFinal': 3,
        'result_test1': 12,
        'result_test2': 34,
        'result_test3': 5,
      };

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/dashboard': (context) => const Scaffold(body: Text('Dashboard')),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/') {
              return MaterialPageRoute(
                builder: (context) => EvaluationResultScreen(),
                settings: RouteSettings(arguments: args),
              );
            }
            return null;
          },
          initialRoute: '/',
        ),
      );

      // Verifica textos principales
      expect(find.text('¡Evaluación completada!'), findsOneWidget);
      expect(find.text('Tu nivel de inversor es'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      // Verifica los resultados de las pruebas
      expect(find.text('Prueba 1'), findsOneWidget);
      expect(find.text('12 respiraciones'), findsOneWidget);
      expect(find.text('Prueba 2'), findsOneWidget);
      expect(find.text('34 segundos'), findsOneWidget);
      expect(find.text('Prueba 3'), findsOneWidget);
      expect(find.text('5 respiraciones'), findsOneWidget);

      // Verifica el botón y la navegación
      expect(find.text('Ir a mi Dashboard'), findsOneWidget);
      await tester.tap(find.text('Ir a mi Dashboard'));
      await tester.pumpAndSettle();
      expect(find.text('Dashboard'), findsOneWidget);
    },
  );
}
