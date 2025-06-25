import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/controllers/register_controller.dart';
import 'package:breath_bank/widgets/app_button.dart';
import 'package:breath_bank/widgets/register_form.dart';
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
  late RegisterController registerController;

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

    registerController = RegisterController(db: dbService);
  });

  testWidgets('RegisterForm muestra todos los campos y el botón', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterForm(injectedController: registerController),
        ),
      ),
    );

    expect(find.byType(TextFieldForm), findsNWidgets(4));
    expect(find.text(Strings.name), findsOneWidget);
    expect(find.text(Strings.email), findsOneWidget);
    expect(find.text(Strings.password), findsOneWidget);
    expect(find.text(Strings.confirmPassword), findsOneWidget);
    expect(find.byType(AppButton), findsOneWidget);
    expect(find.text(Strings.register), findsOneWidget);
  });

  testWidgets('Muestra los campos de nombre, email y contraseña', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterForm(injectedController: registerController),
        ),
      ),
    );

    expect(find.byType(TextFieldForm), findsNWidgets(4));
    expect(find.widgetWithText(TextFieldForm, Strings.name), findsOneWidget);
    expect(find.widgetWithText(TextFieldForm, Strings.email), findsOneWidget);
    expect(
      find.widgetWithText(TextFieldForm, Strings.password),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(TextFieldForm, Strings.confirmPassword),
      findsOneWidget,
    );
  });

  testWidgets('Muestra error si el email está vacío', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterForm(injectedController: registerController),
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.name),
      'nombre',
    );

    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.email),
      '',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.password),
      '123456',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.confirmPassword),
      '123456',
    );
    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(find.text(Strings.emptyEmail), findsOneWidget);
  });

  testWidgets('Muestra error si la contraseña está vacía', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterForm(injectedController: registerController),
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.name),
      'nombre',
    );

    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.email),
      'test@mail.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.password),
      '',
    );

    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.confirmPassword),
      '123456',
    );

    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(find.text(Strings.emptyPassword), findsOneWidget);
  });

  testWidgets('Muestra error si la confirmación de contraseña está vacía', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterForm(injectedController: registerController),
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.name),
      'nombre',
    );

    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.email),
      'test@mail.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.password),
      '123456',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.confirmPassword),
      '',
    );
    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(find.text(Strings.emptyConfirmPassword), findsOneWidget);
  });
  testWidgets('Muestra error si las contraseñas no coinciden', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterForm(injectedController: registerController),
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.name),
      'nombre',
    );

    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.email),
      'test@mail.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.password),
      '123456',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.confirmPassword),
      '124567',
    );
    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(find.text(Strings.passwordMismatch), findsOneWidget);
  });

  testWidgets('Muestra error si el nombre está vacío', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterForm(injectedController: registerController),
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.name),
      '',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.email),
      'test@mail.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.password),
      '123456',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.confirmPassword),
      '123456',
    );
    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(find.text(Strings.emptyName), findsOneWidget);
  });

  testWidgets('Muestra error si el email está vacío', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterForm(injectedController: registerController),
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.name),
      'nombre',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.email),
      '',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.password),
      '123456',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.confirmPassword),
      '123456',
    );
    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(find.text(Strings.emptyEmail), findsOneWidget);
  });

  testWidgets('Muestra error si la contraseña está vacía', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterForm(injectedController: registerController),
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.name),
      'nombre',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.email),
      'test@mail.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.password),
      '',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.confirmPassword),
      '123456',
    );
    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(find.text(Strings.emptyPassword), findsOneWidget);
  });

  testWidgets('Muestra error si la repetición de contraseña está vacía', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterForm(injectedController: registerController),
        ),
      ),
    );

    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.name),
      'nombre',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.email),
      'test@mail.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.password),
      '123456',
    );
    await tester.enterText(
      find.widgetWithText(TextFieldForm, Strings.confirmPassword),
      '',
    );
    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(find.text(Strings.emptyConfirmPassword), findsOneWidget);
  });
}
