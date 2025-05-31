import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:breath_bank/authentication_service.dart';
import 'authentication_service_test.mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late AuthenticationService authService;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    // ✅ Stub del stream authStateChanges (importante antes de instanciar AuthenticationService)
    when(mockFirebaseAuth.authStateChanges()).thenAnswer(
      (_) =>
          Stream<
            User?
          >.empty(), // o usa Stream.value(mockUser) si quieres simular un usuario logueado
    );
    authService = AuthenticationService(firebaseAuth: mockFirebaseAuth);
  });

  test('signIn actualiza userNotifier con el usuario autenticado', () async {
    when(mockUserCredential.user).thenReturn(mockUser);
    when(
      mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: '123456',
      ),
    ).thenAnswer((_) async => mockUserCredential);

    final result = await authService.signIn(
      email: 'test@example.com',
      password: '123456',
    );

    expect(result.user, mockUser);
    expect(authService.userNotifier.value, mockUser);
  });

  test('createAccount actualiza userNotifier con el nuevo usuario', () async {
    when(mockUserCredential.user).thenReturn(mockUser);
    when(
      mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'new@example.com',
        password: 'abcdef',
      ),
    ).thenAnswer((_) async => mockUserCredential);

    final result = await authService.createAccount(
      email: 'new@example.com',
      password: 'abcdef',
    );

    expect(result.user, mockUser);
    expect(authService.userNotifier.value, mockUser);
  });

  test('signOut limpia el userNotifier', () async {
    when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});
    authService.userNotifier.value = mockUser;

    await authService.signOut();

    expect(authService.userNotifier.value, null);
  });

  test('resetPassword envía correo de recuperación', () async {
    when(
      mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com'),
    ).thenAnswer((_) async {});

    await authService.resetPassword(email: 'test@example.com');

    verify(
      mockFirebaseAuth.sendPasswordResetEmail(email: 'test@example.com'),
    ).called(1);
  });

  test('updateUsername actualiza el displayName del usuario', () async {
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(mockUser.updateDisplayName('NuevoNombre')).thenAnswer((_) async {});

    await authService.updateUsername(username: 'NuevoNombre');

    verify(mockUser.updateDisplayName('NuevoNombre')).called(1);
  });

  test('deleteAccount reautentica y elimina el usuario', () async {
    final credential = MockAuthCredential();

    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(
      mockUser.reauthenticateWithCredential(any),
    ).thenAnswer((_) async => mockUserCredential);
    when(mockUser.delete()).thenAnswer((_) async {});
    when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

    await authService.deleteAccount(
      email: 'test@example.com',
      password: '123456',
    );

    verify(mockUser.reauthenticateWithCredential(any)).called(1);
    verify(mockUser.delete()).called(1);
    verify(mockFirebaseAuth.signOut()).called(1);
    expect(authService.userNotifier.value, null);
  });

  test(
    'resetPasswordFromCurrentPassword reautentica y cambia contraseña',
    () async {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(
        mockUser.reauthenticateWithCredential(any),
      ).thenAnswer((_) async => mockUserCredential);
      when(mockUser.updatePassword('newPass123')).thenAnswer((_) async {});

      await authService.resetPasswordFromCurrentPassword(
        email: 'test@example.com',
        currentPassword: 'oldPass',
        newPassword: 'newPass123',
      );

      verify(mockUser.reauthenticateWithCredential(any)).called(1);
      verify(mockUser.updatePassword('newPass123')).called(1);
    },
  );
}
