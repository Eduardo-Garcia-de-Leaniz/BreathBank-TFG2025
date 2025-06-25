import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/evaluation_info_widget.dart';
import 'package:breath_bank/constants/privacy_strings.dart';
import 'package:breath_bank/constants/strings.dart';

void main() {
  group('EvaluationInfoWidget', () {
    testWidgets('muestra el título y la descripción', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: EvaluationInfoWidget())),
      );

      expect(find.text(Strings.evaluationInfoTitle), findsOneWidget);

      expect(find.text(Strings.evaluationInfo), findsOneWidget);
    });

    testWidgets('tiene estilos de texto correctos', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: EvaluationInfoWidget())),
      );

      final titleText = tester.widget<Text>(
        find.text(Strings.evaluationInfoTitle),
      );
      final descriptionText = tester.widget<Text>(
        find.text(Strings.evaluationInfo),
      );

      expect(titleText.style, PrivacyStrings.titleStyle);
      expect(descriptionText.style, PrivacyStrings.descriptionStyle);
      expect(descriptionText.textAlign, TextAlign.justify);
    });

    testWidgets('is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(height: 100, child: EvaluationInfoWidget()),
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
