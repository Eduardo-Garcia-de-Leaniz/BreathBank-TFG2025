import 'package:breath_bank/views/base_screen.dart';
import 'package:breath_bank/views/test2_screen.dart';
import 'package:breath_bank/widgets/arrow_next_symbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test2Screen muestra los textos principales', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: Test2Screen()));

    expect(find.byType(BaseScreen), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(6));
    expect(find.byType(ArrowNextSymbol), findsOneWidget);
  });
}
