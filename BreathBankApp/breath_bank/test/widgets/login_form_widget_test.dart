import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/controllers/login_controller.dart';
import 'package:breath_bank/widgets/app_button.dart';
import 'package:breath_bank/widgets/login_form.dart';
import 'package:breath_bank/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:breath_bank/database_service.dart';

import '../services/authentication_service_test.mocks.dart';
import '../services/database_service_test.mocks.dart';

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDoc;
  late DatabaseService dbService;
  late MockFirebaseAuth mockFirebaseAuth;
  late LoginController loginController;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDoc = MockDocumentReference();

    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);

    dbService = DatabaseService(firestore: mockFirestore);

    mockFirebaseAuth = MockFirebaseAuth();
    when(
      mockFirebaseAuth.authStateChanges(),
    ).thenAnswer((_) => Stream<User?>.empty());

    loginController = LoginController(db: dbService);
  });

  group('LoginFormWidget', () {
    testWidgets('Muestra los campos de email y contraseña', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(
              injectedController: loginController,
              desdeNotificacion: false,
            ),
          ),
        ),
      );

      expect(find.byType(TextFieldForm), findsNWidgets(2));
      expect(find.widgetWithText(TextFieldForm, Strings.email), findsOneWidget);
      expect(
        find.widgetWithText(TextFieldForm, Strings.password),
        findsOneWidget,
      );
    });

    testWidgets('Muestra error si el email está vacío', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(
              injectedController: loginController,
              desdeNotificacion: false,
            ),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFieldForm, Strings.email),
        '',
      );
      await tester.enterText(
        find.widgetWithText(TextFieldForm, Strings.password),
        '123456',
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(find.text(Strings.login), findsOneWidget);
    });

    testWidgets('Muestra error si la contraseña está vacía', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(
              injectedController: loginController,
              desdeNotificacion: false,
            ),
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFieldForm, Strings.email),
        'test@mail.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFieldForm, Strings.password),
        '',
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(find.text(Strings.emptyPassword), findsOneWidget);
    });
  });

  testWidgets('Muestra error si el email es inválido', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoginForm(
            injectedController: loginController,
            desdeNotificacion: false,
          ),
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.email),
      'correoSinArroba.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.password),
      '123456',
    );
    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(find.text(Strings.invalidEmail), findsOneWidget);
  });

  testWidgets('Muestra error si la contraseña no es válida', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoginForm(
            injectedController: loginController,
            desdeNotificacion: false,
          ),
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.email),
      'correo@conArroba.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.password),
      '123',
    );
    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(find.text(Strings.passwordTooShort), findsOneWidget);
  });
}
