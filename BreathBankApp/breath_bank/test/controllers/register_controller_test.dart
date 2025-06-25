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
    test('devuelve error si el nombre está vacío', () async {
      final credentials = UserCredentialsRegister(
        name: '',
        email: 'test@example.com',
        password: '123456',
        confirmPassword: '123456',
      );
      final result = await registerController.validate(credentials);
      expect(result, 'Introduce un nombre de usuario');
    });

    test('devuelve error si el correo electrónico está vacío', () async {
      final credentials = UserCredentialsRegister(
        name: 'Test',
        email: '',
        password: '123456',
        confirmPassword: '123456',
      );
      final result = await registerController.validate(credentials);
      expect(result, 'Introduce un correo electrónico');
    });

    test('devuelve error si el correo electrónico no es válido', () async {
      final credentials = UserCredentialsRegister(
        name: 'Test',
        email: 'invalidemail',
        password: '123456',
        confirmPassword: '123456',
      );
      final result = await registerController.validate(credentials);
      expect(result, 'Correo electrónico inválido');
    });

    test('devuelve error si la contraseña está vacía', () async {
      final credentials = UserCredentialsRegister(
        name: 'Test',
        email: 'test@example.com',
        password: '',
        confirmPassword: '',
      );
      final result = await registerController.validate(credentials);
      expect(result, 'Introduce una contraseña');
    });

    test('devuelve error si la contraseña es demasiado corta', () async {
      final credentials = UserCredentialsRegister(
        name: 'Test',
        email: 'test@example.com',
        password: '123',
        confirmPassword: '123',
      );
      final result = await registerController.validate(credentials);
      expect(result, 'La contraseña debe tener al menos 6 caracteres');
    });

    test('devuelve error si las contraseñas no coinciden', () async {
      final credentials = UserCredentialsRegister(
        name: 'Test',
        email: 'test@example.com',
        password: '123456',
        confirmPassword: '654321',
      );
      final result = await registerController.validate(credentials);
      expect(result, 'Las contraseñas no coinciden');
    });

    test('devuelve null si todos los campos son válidos', () async {
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

  group('RegisterController.getNombreUsuario', () {
    test('devuelve el nombre si existe', () async {
      when(
        mockDoc.get(),
      ).thenAnswer((_) async => MockDocumentSnapshot<Map<String, dynamic>>());
      final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.data()).thenReturn({'Nombre': 'Carlos'});

      final nombre = await registerController.getNombreUsuario('user123');
      expect(nombre, 'Carlos');
    });

    test('devuelve null si el snapshot no existe', () async {
      final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(false);

      final nombre = await registerController.getNombreUsuario('user123');
      expect(nombre, isNull);
    });
  });
}
