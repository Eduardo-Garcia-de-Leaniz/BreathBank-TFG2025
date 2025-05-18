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
              (context) =>
                  const Scaffold(body: Text(RegisterStrings.registerTitle)),
        },
        home: Scaffold(body: ClickableTextLoginRegister(isLogin: true)),
      ),
    );

    expect(find.text(LoginStrings.dontHaveAccount), findsOneWidget);
    expect(find.text(LoginStrings.registerButton), findsOneWidget);

    await tester.tap(find.text(LoginStrings.registerButton));
    await tester.pumpAndSettle();
    expect(find.text(RegisterStrings.registerTitle), findsOneWidget);
  });

  testWidgets('ClickableTextLoginRegister muestra texto de registro y navega', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {'/login': (context) => const Scaffold(body: Text('Login'))},
        home: Scaffold(body: ClickableTextLoginRegister(isLogin: false)),
      ),
    );

    expect(find.text(LoginStrings.alreadyHaveAccount), findsOneWidget);
    expect(find.text(LoginStrings.loginTitle), findsOneWidget);

    await tester.tap(find.text(LoginStrings.loginTitle));
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsOneWidget);
  });
}
