import 'package:breath_bank/constants/info_strings.dart';
import 'package:breath_bank/views/info_app_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('InfoAppSettingsScreen renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: InfoAppSettingsScreen()));

    // Verifica que el título está presente
    expect(find.text(InfoStrings.screenTitle), findsWidgets);

    // Verifica que la descripción de la app está presente
    expect(
      find.textContaining('BreathBank es una aplicación diseñada'),
      findsOneWidget,
    );

    // Verifica que el icono de información está presente
    expect(find.byIcon(Icons.info_outline), findsOneWidget);

    // Verifica que el logo está presente
    expect(find.byType(Image), findsWidgets);
  });
}
