import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/models/user_credentials.dart';

void main() {
  group('UserCredentials', () {
    test('se crea correctamente con email y password', () {
      final creds = UserCredentials(
        email: 'test@email.com',
        password: '123456',
      );
      expect(creds.email, 'test@email.com');
      expect(creds.password, '123456');
    });
  });

  group('UserCredentialsRegister', () {
    test('se crea correctamente con todos los campos', () {
      final creds = UserCredentialsRegister(
        email: 'test@email.com',
        password: '123456',
        confirmPassword: '123456',
        name: 'Test User',
      );
      expect(creds.email, 'test@email.com');
      expect(creds.password, '123456');
      expect(creds.confirmPassword, '123456');
      expect(creds.name, 'Test User');
    });
  });
}
