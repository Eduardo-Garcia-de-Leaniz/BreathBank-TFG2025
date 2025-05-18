import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/views/menu_template_screen.dart';

void main() {
  testWidgets('MenuTemplateScreen muestra tabs y navega entre ellos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MenuTemplateScreen(
          title: 'Mi Menú',
          currentIndex: 0,
          tabs: const [Tab(text: 'Tab 1'), Tab(text: 'Tab 2')],
          tabViews: const [
            Center(child: Text('Contenido 1')),
            Center(child: Text('Contenido 2')),
          ],
        ),
      ),
    );

    // Verifica el título del AppBar
    expect(find.text('Mi Menú'), findsOneWidget);

    // Verifica los tabs
    expect(find.text('Tab 1'), findsOneWidget);
    expect(find.text('Tab 2'), findsOneWidget);

    // Verifica el contenido inicial
    expect(find.text('Contenido 1'), findsOneWidget);
    expect(find.text('Contenido 2'), findsNothing);

    // Cambia al segundo tab
    await tester.tap(find.text('Tab 2'));
    await tester.pumpAndSettle();

    expect(find.text('Contenido 2'), findsOneWidget);
    expect(find.text('Contenido 1'), findsNothing);
  });
}
