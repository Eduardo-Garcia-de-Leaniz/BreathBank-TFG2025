import 'package:breath_bank/views/manual_investment_info_screen.dart';
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

    testWidgets('muestra la pantalla de información de inversión manual', (
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

    testWidgets(
      'navega a la pantalla de inversión manual al presionar el botón',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildTestableWidget(args: args));
        await tester.pumpAndSettle();

        final button =
            find.widgetWithText(ElevatedButton, Strings.startInvestment).first;
        expect(button, findsOneWidget);

        await tester.tap(button, warnIfMissed: false);
        await tester.pumpAndSettle();
      },
    );

    testWidgets('muestra la primera página de contenido al deslizar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(args: args));
      await tester.pumpAndSettle();

      final pageView = find.byType(ManualInvestmentInfoScreen);
      expect(pageView, findsOneWidget);

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

    testWidgets('muestra la segunda página de contenido', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(args: args));
      await tester.pumpAndSettle();

      final pageView = find.byType(ManualInvestmentInfoScreen);

      await tester.drag(pageView, const Offset(-400, 0));
      await tester.pumpAndSettle();
      await tester.drag(pageView, const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.text(Strings.countdownManualInvestmentTitle), findsOneWidget);
      expect(find.text(Strings.countdownManualInvestmentDesc), findsOneWidget);
    });

    testWidgets('muestra la tercera página de contenido', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(args: args));
      await tester.pumpAndSettle();

      final pageView = find.byType(ManualInvestmentInfoScreen);

      for (int i = 0; i < 3; i++) {
        await tester.drag(pageView, const Offset(-400, 0));
        await tester.pumpAndSettle();
      }

      expect(find.text(Strings.duringManualInvestmentTitle), findsOneWidget);
      expect(find.text(Strings.duringManualInvestmentDesc), findsOneWidget);
    });

    testWidgets('muestra la cuarta página de contenido y el botón funciona', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(args: args));
      await tester.pumpAndSettle();

      final pageView = find.byType(ManualInvestmentInfoScreen);

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
