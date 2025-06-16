import 'package:breath_bank/constants/info_strings.dart';
import 'package:breath_bank/views/info_app_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('InfoAppSettingsScreen renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: InfoAppSettingsScreen()));

    expect(find.text(InfoStrings.screenTitle), findsWidgets);

    expect(
      find.textContaining('BreathBank es una aplicación diseñada'),
      findsOneWidget,
    );

    expect(find.byIcon(Icons.info_outline), findsOneWidget);

    expect(find.byType(Image), findsWidgets);
  });
}
