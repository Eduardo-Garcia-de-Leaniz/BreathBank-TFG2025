import 'package:breath_bank/views/guided_investment_info_screen.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestableWidget({required Map<String, dynamic> args}) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(800, 1600)),
        child: Builder(
          builder: (context) {
            return Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => GuidedInvestmentInfoScreen(),
                  settings: RouteSettings(arguments: args),
                );
              },
            );
          },
        ),
      ),
    );
  }

  group('ManualInvestmentInfoScreen', () {
    final args = {'liston': 'Barra 1', 'duracion': 5};

    testWidgets('displays main info page with correct data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(args: args));
      await tester.pumpAndSettle();

      expect(find.text(Strings.guidedInvestmentInfoTitle), findsOneWidget);
      expect(find.textContaining('Barra 1'), findsOneWidget);
      expect(find.textContaining('5 minutos'), findsOneWidget);
      expect(find.text(Strings.investmentResume), findsOneWidget);
    });
    testWidgets('navigates to guided investment on button tap', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(args: args));
      await tester.pumpAndSettle();

      final button = find.widgetWithText(
        ElevatedButton,
        Strings.startInvestment,
      );
      expect(button, findsOneWidget);

      await tester.tap(button, warnIfMissed: false);
      await tester.pumpAndSettle();
    });

    testWidgets('shows FirstPageContent when swiped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(args: args));
      await tester.pumpAndSettle();

      final pageView = find.byType(GuidedInvestmentInfoScreen);
      expect(pageView, findsOneWidget);

      await tester.fling(pageView, const Offset(-400, 0), 100);
      await tester.pumpAndSettle();

      expect(
        find.text(Strings.beforeStartManualInvestmentTitle),
        findsOneWidget,
      );
      expect(
        find.text(Strings.beforeStartGuidedInvestmentDesc),
        findsOneWidget,
      );
    });

    testWidgets('shows SecondPageContent', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(args: args));
      await tester.pumpAndSettle();

      final pageView = find.byType(GuidedInvestmentInfoScreen);

      await tester.drag(pageView, const Offset(-400, 0));
      await tester.pumpAndSettle();
      await tester.drag(pageView, const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.text(Strings.countdownManualInvestmentTitle), findsOneWidget);
      expect(find.text(Strings.countdownManualInvestmentDesc), findsOneWidget);
    });

    testWidgets('shows ThirdPageContent', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(args: args));
      await tester.pumpAndSettle();

      final pageView = find.byType(GuidedInvestmentInfoScreen);

      for (int i = 0; i < 3; i++) {
        await tester.drag(pageView, const Offset(-400, 0));
        await tester.pumpAndSettle();
      }

      expect(find.text(Strings.duringManualInvestmentTitle), findsOneWidget);
      expect(find.text(Strings.duringGuidedInvestmentDesc), findsOneWidget);
    });

    testWidgets('shows FourthPageContent and button works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(args: args));
      await tester.pumpAndSettle();

      final pageView = find.byType(GuidedInvestmentInfoScreen);

      for (int i = 0; i < 4; i++) {
        await tester.drag(pageView, const Offset(-400, 0));
        await tester.pumpAndSettle();
      }

      expect(find.text(Strings.endManualInvestmentTitle), findsOneWidget);
      expect(find.text(Strings.endGuidedInvestmentDesc), findsOneWidget);

      final button = find.widgetWithText(
        ElevatedButton,
        Strings.startInvestment,
      );
      expect(button, findsOneWidget);
    });
  });
}
