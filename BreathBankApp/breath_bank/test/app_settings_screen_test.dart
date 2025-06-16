import 'package:breath_bank/views/app_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest({NavigatorObserver? observer}) {
    return MaterialApp(
      home: const AppSettingsScreen(),
      routes: {
        '/dashboard/appsettings/info':
            (context) => const Placeholder(key: Key('info_screen')),
        '/dashboard/appsettings/privacysettings':
            (context) => const Placeholder(key: Key('privacy_screen')),
        '/dashboard/appsettings/legaladvice':
            (context) => const Placeholder(key: Key('legal_screen')),
        '/dashboard/appsettings/helpsupport':
            (context) => const Placeholder(key: Key('help_screen')),
      },
      navigatorObservers: observer != null ? [observer] : [],
    );
  }

  testWidgets('AppSettingsScreen displays main UI elements', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // AppBar title
    expect(find.text('Configuración de la app'), findsWidgets);

    // Avatar and icon
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);

    // Subtitle
    expect(find.text('Configuración de la App'), findsOneWidget);

    // Info text
    expect(
      find.textContaining(
        'Notificaciones y Personalizar interfaz estarán disponibles pronto.',
      ),
      findsOneWidget,
    );

    // Option tiles
    expect(find.byType(Card), findsNWidgets(5));

    // Disabled tiles have correct color
    final cards = tester.widgetList<Card>(find.byType(Card)).toList();
    expect(cards[0].color, isNotNull); // Notificaciones
    expect(cards[1].color, isNotNull); // Personalizar interfaz
  });

  testWidgets(
    'AppSettingsScreen disables Notificaciones and Personalizar interfaz',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Try to tap disabled tiles
      await tester.tap(find.text('Notificaciones'));
      await tester.pumpAndSettle();
      // Should not navigate anywhere, still on the same screen
      expect(find.text('Configuración de la app'), findsWidgets);

      await tester.tap(find.text('Personalizar interfaz'));
      await tester.pumpAndSettle();
      expect(find.text('Configuración de la app'), findsWidgets);
    },
  );

  testWidgets('AppSettingsScreen has correct padding and scrolls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Padding
    final padding = tester.widget<Padding>(find.byType(Padding).first);
    expect(padding.padding, const EdgeInsets.all(16.0));

    // ListView is present and scrollable
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets(
    'Tapping "Acerca de la app" navega a /dashboard/appsettings/info',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Acerca de la app'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('info_screen')), findsOneWidget);
    },
  );

  testWidgets(
    'Tapping "Privacidad" navega a /dashboard/appsettings/privacysettings',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Privacidad'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('privacy_screen')), findsOneWidget);
    },
  );
}
