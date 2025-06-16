import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/investment_info_widget.dart';
import 'package:breath_bank/constants/privacy_strings.dart';
import 'package:breath_bank/constants/strings.dart';

void main() {
  group('InvestmentInfoWidget', () {
    testWidgets('renders title and description', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: InvestmentInfoWidget())),
      );

      expect(find.text(Strings.investmentInfoTitle), findsOneWidget);

      expect(find.text(Strings.investmentInfo), findsOneWidget);
    });

    testWidgets('has correct text styles', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: InvestmentInfoWidget())),
      );

      final titleText = tester.widget<Text>(
        find.text(Strings.investmentInfoTitle),
      );
      final descriptionText = tester.widget<Text>(
        find.text(Strings.investmentInfo),
      );

      expect(titleText.style, PrivacyStrings.titleStyle);
      expect(descriptionText.style, PrivacyStrings.descriptionStyle);
      expect(descriptionText.textAlign, TextAlign.justify);
    });

    testWidgets('is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(height: 100, child: InvestmentInfoWidget()),
          ),
        ),
      );

      final gesture = await tester.startGesture(const Offset(0, 50));
      await gesture.moveBy(const Offset(0, -50));
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
