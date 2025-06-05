import 'package:breath_bank/constants/legal_strings.dart';
import 'package:breath_bank/constants/privacy_strings.dart';
import 'package:breath_bank/views/legal_advice_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(home: LegalAdviceSettingsScreen());
  }

  testWidgets('LegalAdviceSettingsScreen displays all legal sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Title and icon
    expect(find.byIcon(Icons.gavel), findsOneWidget);
    expect(find.text(LegalStrings.screenTitle), findsWidgets);

    // Section titles
    expect(find.text(LegalStrings.generalInfoTitle), findsOneWidget);
    expect(find.text(LegalStrings.noMedicalAdviceTitle), findsOneWidget);
    expect(find.text(LegalStrings.limitedResponsibilityTitle), findsOneWidget);
    expect(
      find.text(LegalStrings.academicUseAndInvestigationTitle),
      findsOneWidget,
    );
    expect(find.text(LegalStrings.propertyRightsTitle), findsOneWidget);
    expect(find.text(LegalStrings.changesToPolicyTitle), findsOneWidget);

    // Section descriptions
    expect(find.text(LegalStrings.descInfo), findsOneWidget);
    expect(find.text(LegalStrings.descNoMedicalAdvice), findsOneWidget);
    expect(find.text(LegalStrings.descLimitedResponsibility), findsOneWidget);
    expect(
      find.text(LegalStrings.descAcademicUseAndInvestigation),
      findsOneWidget,
    );
    expect(find.text(LegalStrings.descPropertyRights), findsOneWidget);
    expect(find.text(LegalStrings.descChangesToPolicy), findsOneWidget);

    // Date string
    final today = DateTime.now();
    final dateString = PrivacyStrings.date.replaceAll(
      '{0}',
      '${today.day}/${today.month}/${today.year}',
    );
    expect(find.text(dateString), findsOneWidget);
  });

  testWidgets('LegalAdviceSettingsScreen uses correct styles', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final titleText = tester.widget<Text>(
      find.text(LegalStrings.generalInfoTitle),
    );
    expect(titleText.style, PrivacyStrings.titleStyle);

    final descText = tester.widget<Text>(find.text(LegalStrings.descInfo));
    expect(descText.style, PrivacyStrings.descriptionStyle);
    expect(descText.textAlign, TextAlign.justify);
  });
}
