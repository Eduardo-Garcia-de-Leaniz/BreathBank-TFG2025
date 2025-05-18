import 'package:breath_bank/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/views/home_screen.dart';

void main() {
  testWidgets('HomeScreen muestra los textos y botones principales', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Verifica que el título y subtítulo estén presentes
    expect(find.text(HomeStrings.appTitle), findsOneWidget);
    expect(find.text(HomeStrings.welcome), findsOneWidget);

    // Verifica que los botones estén presentes
    expect(find.text(HomeStrings.login), findsOneWidget);
    expect(find.text(HomeStrings.register), findsOneWidget);
  });

  testWidgets('HomeScreen navega al pulsar los botones', (
    WidgetTester tester,
  ) async {
    final List<String> pushedRoutes = [];

    await tester.pumpWidget(
      MaterialApp(
        home: const HomeScreen(),
        onGenerateRoute: (settings) {
          pushedRoutes.add(settings.name ?? '');
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('Nueva pantalla')),
            settings: settings,
          );
        },
      ),
    );

    // Pulsa "Iniciar Sesión"
    await tester.tap(find.text(HomeStrings.login));
    await tester.pumpAndSettle();
    expect(pushedRoutes.contains('/login'), isTrue);
  });
}
