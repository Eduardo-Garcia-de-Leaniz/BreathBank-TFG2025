import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/controllers/account_settings_controller.dart';
import 'package:breath_bank/controllers/register_controller.dart';
import 'package:breath_bank/database_service.dart';
import 'package:breath_bank/models/user_credentials.dart';
import 'package:breath_bank/views/account_settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'services/authentication_service_test.mocks.dart';
import 'services/database_service_test.mocks.dart';

void main() {
  late AccountSettingsController accountSettingsController;
  late MockFirebaseFirestore mockFirestore;
  late MockDocumentReference<Map<String, dynamic>> mockDoc;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late AuthenticationService authService;
  late AccountSettingsScreen accountSettingsScreen;

  late DatabaseService dbService;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockDoc = MockDocumentReference<Map<String, dynamic>>();
    final mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
    when(mockDoc.get()).thenAnswer((_) async => mockDocumentSnapshot);
    when(mockDocumentSnapshot.data()).thenReturn({
      'Nombre': 'Test User',
      'nombre': 'Test User',
      'Email': 'test@example.com',
      'email': 'test@example.com',
    });
    when(mockDocumentSnapshot.exists).thenReturn(true);
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);
    dbService = DatabaseService(firestore: mockFirestore);
    mockUser = MockUser();
    when(mockUser.uid).thenReturn('test_uid');
    mockUserCredential = MockUserCredential();
    mockFirebaseAuth = MockFirebaseAuth();
    when(
      mockFirebaseAuth.authStateChanges(),
    ).thenAnswer((_) => Stream<User?>.empty());
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

    authService = AuthenticationService(firebaseAuth: mockFirebaseAuth);

    accountSettingsController = AccountSettingsController(
      db: dbService,
      authenticationService: authService,
    );

    when(
      mockFirebaseAuth.authStateChanges(),
    ).thenAnswer((_) => Stream<User?>.empty());
  });

  testWidgets('Contiene todas las opciones principales', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AccountSettingsScreen(controller: accountSettingsController),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Consultar datos'), findsOneWidget);
    expect(find.textContaining('Cambiar contraseña'), findsOneWidget);
    expect(find.textContaining('Eliminar historial'), findsOneWidget);
    expect(find.textContaining('Cerrar sesión'), findsOneWidget);
    expect(find.textContaining('Eliminar cuenta'), findsOneWidget);
  });
}
