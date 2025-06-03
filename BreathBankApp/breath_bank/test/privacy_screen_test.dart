import 'package:breath_bank/constants/privacy_strings.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/views/privacy_screen.dart';
import 'package:breath_bank/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: child,
      routes: {
        '/evaluation':
            (context) => const Scaffold(body: Text('Evaluation Screen')),
      },
    );
  }

  testWidgets('PrivacyScreen renders all sections and checkboxes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(const PrivacyScreen()));

    expect(find.text(PrivacyStrings.privacyPolicy), findsWidgets);

    expect(find.text(PrivacyStrings.introductionTitle), findsOneWidget);
    expect(find.text(PrivacyStrings.informationWeCollectTitle), findsOneWidget);
    expect(find.text(PrivacyStrings.useOfInformationTitle), findsOneWidget);
    expect(find.text(PrivacyStrings.dataProtectionTitle), findsOneWidget);
    expect(find.text(PrivacyStrings.userRightsTitle), findsOneWidget);
    expect(find.text(PrivacyStrings.changesToPolicyTitle), findsOneWidget);

    expect(find.text(PrivacyStrings.acceptanceStatement), findsOneWidget);
    expect(find.text(PrivacyStrings.futureUseConsentStatement), findsOneWidget);

    final continueButton = find.widgetWithText(
      AppButton,
      Strings.continueButton,
    );
    expect(continueButton, findsOneWidget);
    final AppButton buttonWidget = tester.widget(continueButton);
    expect(buttonWidget.isDisabled, isTrue);
  });

  testWidgets('Checkboxes enable the Continue button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(const PrivacyScreen()));

    final acceptanceCheckbox = find.byWidgetPredicate(
      (w) =>
          w is CheckboxListTile &&
          w.title is Text &&
          (w.title as Text).data == PrivacyStrings.acceptanceStatement,
    );
    final consentCheckbox = find.byWidgetPredicate(
      (w) =>
          w is CheckboxListTile &&
          w.title is Text &&
          (w.title as Text).data == PrivacyStrings.futureUseConsentStatement,
    );

    // Tap only the first checkbox
    await tester.ensureVisible(acceptanceCheckbox);
    await tester.tap(acceptanceCheckbox);
    await tester.pump();
    final continueButton = find.widgetWithText(
      AppButton,
      Strings.continueButton,
    );
    AppButton buttonWidget = tester.widget(continueButton);

    expect(buttonWidget.isDisabled, isTrue);

    await tester.tap(consentCheckbox);
    await tester.pump();
    buttonWidget = tester.widget(continueButton);
    expect(buttonWidget.isDisabled, isFalse);
  });

  testWidgets('Continue button navigates to /evaluation when enabled', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(const PrivacyScreen()));

    final acceptanceCheckbox = find.byWidgetPredicate(
      (w) =>
          w is CheckboxListTile &&
          w.title is Text &&
          (w.title as Text).data == PrivacyStrings.acceptanceStatement,
    );
    final consentCheckbox = find.byWidgetPredicate(
      (w) =>
          w is CheckboxListTile &&
          w.title is Text &&
          (w.title as Text).data == PrivacyStrings.futureUseConsentStatement,
    );

    await tester.ensureVisible(acceptanceCheckbox);
    await tester.tap(acceptanceCheckbox);
    await tester.pump();
    await tester.ensureVisible(acceptanceCheckbox);
    await tester.tap(consentCheckbox);
    await tester.pump();

    final continueButton = find.widgetWithText(
      AppButton,
      Strings.continueButton,
    );
    await tester.ensureVisible(acceptanceCheckbox);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(find.byType(Text), findsOneWidget);
  });

  testWidgets('PrivacyScreen displays today\'s date', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(const PrivacyScreen()));
    final today =
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    expect(find.textContaining(today), findsOneWidget);
  });
}
