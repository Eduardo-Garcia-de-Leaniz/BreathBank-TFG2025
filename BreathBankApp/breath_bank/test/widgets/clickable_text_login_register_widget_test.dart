import 'package:breath_bank/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/widgets/clickable_text_login_register.dart';

void main() {
  testWidgets('ClickableTextLoginRegister muestra texto de login y navega', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/register':
              (context) => const Scaffold(body: Text(Strings.register)),
        },
        home: Scaffold(body: ClickableTextLoginRegister(isLogin: true)),
      ),
    );

    expect(find.text(Strings.dontHaveAccount), findsOneWidget);
    expect(find.text(Strings.register), findsOneWidget);

    await tester.tap(find.text(Strings.register));
    await tester.pumpAndSettle();
    expect(find.text(Strings.register), findsOneWidget);
  });

  testWidgets('ClickableTextLoginRegister muestra texto de registro y navega', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/login': (context) => const Scaffold(body: Text(Strings.login)),
        },
        home: Scaffold(body: ClickableTextLoginRegister(isLogin: false)),
      ),
    );

    expect(find.text(Strings.alreadyHaveAccount), findsOneWidget);
    expect(find.text(Strings.login), findsOneWidget);

    await tester.tap(find.text(Strings.login));
    await tester.pumpAndSettle();
    expect(find.text(Strings.login), findsOneWidget);
  });
}
