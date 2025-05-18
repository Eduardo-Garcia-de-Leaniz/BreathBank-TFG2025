import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/navigation_menu.dart';

void main() {
  testWidgets('NavigationMenu muestra los ítems y navega al pulsar', (
    WidgetTester tester,
  ) async {
    final List<String> pushedRoutes = [];
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) {
          pushedRoutes.add(settings.name ?? '');
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('Nueva pantalla')),
            settings: settings,
          );
        },
        home: Scaffold(bottomNavigationBar: NavigationMenu(currentIndex: 0)),
      ),
    );

    expect(find.text('Evaluaciones'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Inversiones'), findsOneWidget);

    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
    expect(pushedRoutes.contains('/dashboard'), isTrue);
  });
}
