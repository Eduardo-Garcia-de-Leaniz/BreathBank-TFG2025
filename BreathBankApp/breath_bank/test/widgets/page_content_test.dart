import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/widgets/image.dart';
import 'package:breath_bank/widgets/page_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PageContent Widget', () {
    testWidgets('renders title, description, and image', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageContent(
              titleText: 'Test Title',
              descText: 'Test Description',
              imagePath: 'assets/images/corriendo_inversion_guiada.png',
              imageWidth: 100,
              imageHeight: 100,
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.byType(ImageWidget), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('shows ElevatedButton when isLastPage is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageContent(
              titleText: 'Final Title',
              descText: 'Final Description',
              imagePath: 'assets/images/corriendo_inversion_guiada.png',
              imageWidth: 120,
              imageHeight: 120,
              isLastPage: true,
            ),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.textContaining(Strings.startInvestment), findsOneWidget);
    });

    testWidgets(
      'tapping button calls Navigator.pushNamed with correct arguments',
      (WidgetTester tester) async {
        final navigatorKey = GlobalKey<NavigatorState>();
        Map<String, dynamic>? receivedArgs;
        String? receivedRoute;

        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            onGenerateRoute: (settings) {
              receivedRoute = settings.name;
              receivedArgs = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(builder: (_) => const SizedBox());
            },
            home: Scaffold(
              body: PageContent(
                titleText: 'Last Page',
                routeName: '/dashboard/newinvestmentmenu/manual',
                descText: 'Desc',
                imagePath: 'assets/images/corriendo_inversion_guiada.png',
                imageWidth: 80,
                imageHeight: 80,
                isLastPage: true,
                args: {'foo': 'bar'},
              ),
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(receivedRoute, '/dashboard/newinvestmentmenu/manual');
        expect(receivedArgs, {'foo': 'bar'});
      },
    );
  });
}
