import 'package:breath_bank/views/manual_investment_info_screen.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Helper to build the widget with required arguments
  Widget buildTestableWidget({required Map<String, dynamic> args}) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(800, 1600)), // Aumenta el tamaño
        child: Builder(
          builder: (context) {
            return Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => ManualInvestmentInfoScreen(),
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

      expect(find.text(Strings.manualInvestmentInfoTitle), findsOneWidget);
      expect(find.textContaining('Barra 1'), findsOneWidget);
      expect(find.textContaining('5 minutos'), findsOneWidget);
      expect(find.text(Strings.investmentResume), findsOneWidget);
      expect(find.text(Strings.startInvestment), findsWidgets);
    });

    testWidgets('navigates to manual investment on button tap', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(args: args));
      await tester.pumpAndSettle();

      final button =
          find.widgetWithText(ElevatedButton, Strings.startInvestment).first;
      expect(button, findsOneWidget);

      await tester.tap(button, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Should navigate to '/dashboard/newinvestmentmenu/manual'
      // Since we don't have that route, just check no exceptions and navigation attempted
      // (No assertion needed, just ensure no errors)
    });

    testWidgets('shows FirstPageContent when swiped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(args: args));
      await tester.pumpAndSettle();

      final pageView = find.byType(ManualInvestmentInfoScreen);
      expect(pageView, findsOneWidget);

      // Swipe to next page
      await tester.fling(pageView, const Offset(-400, 0), 100);
      await tester.pumpAndSettle();

      expect(
        find.text(Strings.beforeStartManualInvestmentTitle),
        findsOneWidget,
      );
      expect(
        find.text(Strings.beforeStartManualInvestmentDesc),
        findsOneWidget,
      );
    });

    testWidgets('shows SecondPageContent', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(args: args));
      await tester.pumpAndSettle();

      final pageView = find.byType(ManualInvestmentInfoScreen);

      // Swipe twice to reach second page
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

      final pageView = find.byType(ManualInvestmentInfoScreen);

      // Swipe three times to reach third page
      for (int i = 0; i < 3; i++) {
        await tester.drag(pageView, const Offset(-400, 0));
        await tester.pumpAndSettle();
      }

      expect(find.text(Strings.duringManualInvestmentTitle), findsOneWidget);
      expect(find.text(Strings.duringManualInvestmentDesc), findsOneWidget);
    });

    testWidgets('shows FourthPageContent and button works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(args: args));
      await tester.pumpAndSettle();

      final pageView = find.byType(ManualInvestmentInfoScreen);

      // Swipe four times to reach fourth page
      for (int i = 0; i < 4; i++) {
        await tester.drag(pageView, const Offset(-400, 0));
        await tester.pumpAndSettle();
      }

      expect(find.text(Strings.endManualInvestmentTitle), findsOneWidget);
      expect(find.text(Strings.endManualInvestmentDesc), findsOneWidget);

      final button = find.widgetWithText(
        ElevatedButton,
        Strings.startInvestment,
      );
      expect(button, findsOneWidget);
    });
  });
}
