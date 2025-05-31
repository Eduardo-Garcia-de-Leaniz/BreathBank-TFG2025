import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/models/user_credentials.dart';
import 'package:breath_bank/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:breath_bank/authentication_service.dart';

import '../services/authentication_service_test.mocks.dart';
import 'login_form_widget_test.mocks.dart';

void main() {
  late MockLoginController mockController;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late AuthenticationService authService;
  late LoginForm loginForm;

  setUp(() {
    mockController = MockLoginController();
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();

    authService = AuthenticationService();
    loginForm = LoginForm(
      desdeNotificacion: false,
      injectedController: mockController,
    );

    // Inyectamos el servicio en la instancia global
    authenticationService.value = authService;

    // Simulamos que el usuario ya está autenticado
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn("uid_test");
  });

  Future<void> pumpLoginForm(WidgetTester tester) async {
    await tester.pumpWidget(loginForm);
  }

  testWidgets('Login exitoso y muestra SnackBar de bienvenida', (tester) async {
    await pumpLoginForm(tester);

    const testEmail = 'test@example.com';
    const testPassword = '123456';
    const nombreUsuario = 'Juan';

    await tester.enterText(find.byType(TextField).at(0), testEmail);
    await tester.enterText(find.byType(TextField).at(1), testPassword);

    final credentials = UserCredentials(
      email: testEmail,
      password: testPassword,
    );

    // Stubs
    when(mockController.validate(any)).thenReturn(null);
    when(mockController.signIn(any)).thenAnswer((_) async => null);
    when(mockController.postLoginTasks("uid_test")).thenAnswer((_) async {});
    when(
      mockController.getNombreUsuario("uid_test"),
    ).thenAnswer((_) async => nombreUsuario);

    // Tap en botón
    await tester.tap(find.text(Strings.login));
    await tester.pumpAndSettle(); // espera animaciones/SnackBar

    expect(
      find.textContaining('Has iniciado sesión correctamente'),
      findsOneWidget,
    );

    verify(mockController.validate(any)).called(1);
    verify(mockController.signIn(any)).called(1);
    verify(mockController.postLoginTasks("uid_test")).called(1);
    verify(mockController.getNombreUsuario("uid_test")).called(1);
  });
}
