import 'package:breath_bank/constants/help_strings.dart';
import 'package:breath_bank/constants/privacy_strings.dart';
import 'package:breath_bank/views/help_support_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(home: HelpSupportSettingsScreen());
  }

  testWidgets('HelpSupportSettingsScreen muestra todos los textos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byIcon(Icons.help), findsOneWidget);
    expect(find.text(HelpStrings.screenTitle), findsWidgets);

    expect(find.text(HelpStrings.generalInfoTitle), findsOneWidget);
    expect(find.text(HelpStrings.frequentQuestionsTitle), findsOneWidget);
    expect(find.text(HelpStrings.contactAndSupportTitle), findsOneWidget);
    expect(find.text(HelpStrings.futureImplementationTitle), findsOneWidget);
    expect(find.text(HelpStrings.greetingsTitle), findsOneWidget);

    expect(find.text(HelpStrings.descInfo), findsOneWidget);
    expect(find.text(HelpStrings.descFrequentQuestions), findsOneWidget);
    expect(find.text(HelpStrings.descContactAndSupport), findsOneWidget);
    expect(find.text(HelpStrings.descFutureImplementation), findsOneWidget);
    expect(find.text(HelpStrings.descGreetings), findsOneWidget);

    final today = DateTime.now();
    final dateString = PrivacyStrings.date.replaceAll(
      '{0}',
      '${today.day}/${today.month}/${today.year}',
    );
    expect(find.text(dateString), findsOneWidget);
  });

  testWidgets('HelpSupportSettingsScreen utiliza los estilos correctos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final titleText = tester.widget<Text>(
      find.text(HelpStrings.generalInfoTitle),
    );
    expect(titleText.style, PrivacyStrings.titleStyle);

    final descText = tester.widget<Text>(find.text(HelpStrings.descInfo));
    expect(descText.style, PrivacyStrings.descriptionStyle);
    expect(descText.textAlign, TextAlign.justify);
  });

  testWidgets('HelpSupportSettingsScreen is scrollable', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final scrollable = find.byType(SingleChildScrollView);
    expect(scrollable, findsWidgets);
  });

  testWidgets('HelpSupportSettingsScreen has correct padding', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final padding = tester.widget<Padding>(find.byType(Padding).first);
    expect(
      padding.padding,
      EdgeInsets.only(top: 30.0, left: 24.0, right: 24.0, bottom: 30.0),
    );
  });
}
