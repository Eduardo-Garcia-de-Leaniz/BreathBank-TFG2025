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
          '/register': (context) => const Scaffold(body: Text('Registro')),
        },
        home: Scaffold(body: ClickableTextLoginRegister(isLogin: true)),
      ),
    );

    expect(find.text('¿No tienes una cuenta? '), findsOneWidget);
    expect(find.text('Registrarse'), findsOneWidget);

    await tester.tap(find.text('Registrarse'));
    await tester.pumpAndSettle();
    expect(find.text('Registro'), findsOneWidget);
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

    expect(find.text('¿Ya tienes una cuenta? '), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);

    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsOneWidget);
  });
}
