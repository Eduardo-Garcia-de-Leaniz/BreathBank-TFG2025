import 'package:breath_bank/constants/privacy_strings.dart';
import 'package:breath_bank/views/privacy_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(home: child);
  }

  testWidgets('PrivacySettingsScreen muestra todas las secciones y textos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(const PrivacySettingsScreen()));

    expect(find.text(PrivacyStrings.privacyPolicy), findsNWidgets(2));

    expect(find.byIcon(Icons.privacy_tip_outlined), findsOneWidget);

    expect(find.text(PrivacyStrings.introductionTitle), findsOneWidget);
    expect(find.text(PrivacyStrings.informationWeCollectTitle), findsOneWidget);
    expect(find.text(PrivacyStrings.useOfInformationTitle), findsOneWidget);
    expect(find.text(PrivacyStrings.dataProtectionTitle), findsOneWidget);
    expect(find.text(PrivacyStrings.userRightsTitle), findsOneWidget);
    expect(find.text(PrivacyStrings.changesToPolicyTitle), findsOneWidget);

    expect(find.text(PrivacyStrings.introductionDescription), findsOneWidget);
    expect(
      find.text(PrivacyStrings.informationWeCollectDescription),
      findsOneWidget,
    );
    expect(
      find.text(PrivacyStrings.howWeUseYourInformationDescription),
      findsOneWidget,
    );
    expect(find.text(PrivacyStrings.dataProtectionDescription), findsOneWidget);
    expect(find.text(PrivacyStrings.userRightsDescription), findsOneWidget);
    expect(
      find.text(PrivacyStrings.changesToPolicyDescription),
      findsOneWidget,
    );

    final today =
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    expect(find.textContaining(today), findsOneWidget);
  });

  testWidgets(
    'PrivacySettingsScreen muestra el texto de aceptación y declaración',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(const PrivacySettingsScreen()),
      );

      expect(find.text(PrivacyStrings.acceptance), findsNothing);
      expect(find.text(PrivacyStrings.acceptanceStatement), findsNothing);
      expect(find.text(PrivacyStrings.futureUseConsentStatement), findsNothing);
    },
  );

  testWidgets(
    'PrivacySettingsScreen tiene los estilos correctos para títulos y descripciones',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(const PrivacySettingsScreen()),
      );

      final titleText = tester.widget<Text>(
        find.text(PrivacyStrings.introductionTitle),
      );
      expect(titleText.style, PrivacyStrings.titleStyle);

      final descText = tester.widget<Text>(
        find.text(PrivacyStrings.introductionDescription),
      );
      expect(descText.style, PrivacyStrings.descriptionStyle);
    },
  );
}
