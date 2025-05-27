import 'package:breath_bank/constants/strings.dart';
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
      expect(find.text(Strings.evaluationCompleted), findsOneWidget);
      expect(find.text(Strings.newLevel), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      // Verifica los resultados de las pruebas
      expect(find.text(Strings.test1), findsOneWidget);
      expect(find.text('12 ${Strings.breathUnits}'), findsOneWidget);
      expect(find.text(Strings.test2), findsOneWidget);
      expect(find.text('34 ${Strings.secondsUnits}'), findsOneWidget);
      expect(find.text(Strings.test3), findsOneWidget);
      expect(find.text('5 ${Strings.breathUnits}'), findsOneWidget);

      // Verifica el botón y la navegación
      expect(find.text(Strings.buttonToDashboard), findsOneWidget);
      await tester.tap(find.text(Strings.buttonToDashboard));
      await tester.pumpAndSettle();
      expect(find.text('Dashboard'), findsOneWidget);
    },
  );
}
