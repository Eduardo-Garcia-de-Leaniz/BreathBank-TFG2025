import 'package:breath_bank/controllers/login_controller.dart';
import 'package:breath_bank/database_service.dart';
import 'package:breath_bank/models/user_credentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../services/authentication_service_test.mocks.dart';
import '../services/database_service_test.mocks.dart';

void main() {
  late LoginController loginController;
  late MockFirebaseFirestore mockFirestore;
  late MockDocumentReference<Map<String, dynamic>> mockDoc;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshot;
  late MockFirebaseAuth mockFirebaseAuth;

  late DatabaseService dbService;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockDoc = MockDocumentReference<Map<String, dynamic>>();
    mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);
    dbService = DatabaseService(firestore: mockFirestore);

    loginController = LoginController(db: dbService);
    mockFirebaseAuth = MockFirebaseAuth();

    when(
      mockFirebaseAuth.authStateChanges(),
    ).thenAnswer((_) => Stream<User?>.empty());
  });

  test('getNombreUsuario llama a getNombreUsuario en el controlador', () async {
    when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
    when(mockSnapshot.exists).thenReturn(true);
    when(mockSnapshot.data()).thenReturn({'Nombre': 'Carlos'});

    final nombre = await loginController.getNombreUsuario('user123');

    expect(nombre, 'Carlos');
  });

  test('LoginController llama a getNombreUsuario al obtener nombre', () async {
    when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
    when(mockSnapshot.exists).thenReturn(true);
    when(mockSnapshot.data()).thenReturn({'Nombre': 'Carlos'});

    final nombre = await loginController.getNombreUsuario('user123');

    expect(nombre, 'Carlos');
  });

  test(
    'postLoginTasks llama a updateFechaUltimoAcceso en DatabaseService',
    () async {
      when(mockDoc.update(any)).thenAnswer((_) async {});
      await loginController.postLoginTasks('user123');
      verify(mockDoc.update(argThat(contains('FechaÚltimoAcceso')))).called(1);
    },
  );

  test('validate retorna error si el email está vacío', () {
    final credentials = UserCredentials(email: '', password: '123456');
    final result = loginController.validate(credentials);
    expect(result, 'Introduce un correo electrónico');
  });

  test('validate retorna error si el email es inválido', () {
    final credentials = UserCredentials(email: 'correo', password: '123456');
    final result = loginController.validate(credentials);
    expect(result, 'Correo electrónico inválido');
  });

  test('validate retorna error si la contraseña está vacía', () {
    final credentials = UserCredentials(email: 'test@mail.com', password: '');
    final result = loginController.validate(credentials);
    expect(result, 'Introduce una contraseña');
  });

  test('validate retorna error si la contraseña es corta', () {
    final credentials = UserCredentials(
      email: 'test@mail.com',
      password: '123',
    );
    final result = loginController.validate(credentials);
    expect(result, 'La contraseña debe tener al menos 6 caracteres');
  });
}
