import 'package:breath_bank/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/views/home_screen.dart';

void main() {
  testWidgets('HomeScreen muestra los textos y botones principales', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text(Strings.appTitle), findsOneWidget);
    expect(find.text(Strings.welcome), findsOneWidget);

    expect(find.text(Strings.login), findsOneWidget);
    expect(find.text(Strings.register), findsOneWidget);
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

    await tester.tap(find.text(Strings.login));
    await tester.pumpAndSettle();
    expect(pushedRoutes.contains('/login'), isTrue);
  });
}
