import 'package:breath_bank/controllers/register_controller.dart';
import 'package:breath_bank/database_service.dart';
import 'package:breath_bank/models/user_credentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../services/authentication_service_test.mocks.dart';
import '../services/database_service_test.mocks.dart';

void main() {
  late RegisterController registerController;
  late MockFirebaseFirestore mockFirestore;
  late MockDocumentReference<Map<String, dynamic>> mockDoc;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockFirebaseAuth mockFirebaseAuth;

  late DatabaseService dbService;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockDoc = MockDocumentReference<Map<String, dynamic>>();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);
    dbService = DatabaseService(firestore: mockFirestore);

    registerController = RegisterController(db: dbService);
    mockFirebaseAuth = MockFirebaseAuth();

    when(
      mockFirebaseAuth.authStateChanges(),
    ).thenAnswer((_) => Stream<User?>.empty());
  });

  group('RegisterController.validate', () {
    test('returns error if name is empty', () async {
      final credentials = UserCredentialsRegister(
        name: '',
        email: 'test@example.com',
        password: '123456',
        confirmPassword: '123456',
      );
      final result = await registerController.validate(credentials);
      expect(result, 'Introduce un nombre de usuario');
    });

    test('returns error if email is empty', () async {
      final credentials = UserCredentialsRegister(
        name: 'Test',
        email: '',
        password: '123456',
        confirmPassword: '123456',
      );
      final result = await registerController.validate(credentials);
      expect(result, 'Introduce un correo electrónico');
    });

    test('returns error if email is invalid', () async {
      final credentials = UserCredentialsRegister(
        name: 'Test',
        email: 'invalidemail',
        password: '123456',
        confirmPassword: '123456',
      );
      final result = await registerController.validate(credentials);
      expect(result, 'Correo electrónico inválido');
    });

    test('returns error if password is empty', () async {
      final credentials = UserCredentialsRegister(
        name: 'Test',
        email: 'test@example.com',
        password: '',
        confirmPassword: '',
      );
      final result = await registerController.validate(credentials);
      expect(result, 'Introduce una contraseña');
    });

    test('returns error if password is too short', () async {
      final credentials = UserCredentialsRegister(
        name: 'Test',
        email: 'test@example.com',
        password: '123',
        confirmPassword: '123',
      );
      final result = await registerController.validate(credentials);
      expect(result, 'La contraseña debe tener al menos 6 caracteres');
    });

    test('returns error if passwords do not match', () async {
      final credentials = UserCredentialsRegister(
        name: 'Test',
        email: 'test@example.com',
        password: '123456',
        confirmPassword: '654321',
      );
      final result = await registerController.validate(credentials);
      expect(result, 'Las contraseñas no coinciden');
    });

    test('returns null if all fields are valid', () async {
      final credentials = UserCredentialsRegister(
        name: 'Test',
        email: 'test@example.com',
        password: '123456',
        confirmPassword: '123456',
      );
      final result = await registerController.validate(credentials);
      expect(result, null);
    });
  });
}
