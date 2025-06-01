import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/controllers/evaluation_controller.dart';
import 'package:breath_bank/controllers/register_controller.dart';
import 'package:breath_bank/database_service.dart';
import 'package:breath_bank/models/evaluation_model.dart';
import 'package:breath_bank/models/user_credentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../services/authentication_service_test.mocks.dart';
import '../services/database_service_test.mocks.dart';

void main() {
  late EvaluationController evaluationController;
  late EvaluationModel evaluationModel;
  late MockFirebaseFirestore mockFirestore;
  late MockDocumentReference<Map<String, dynamic>> mockDoc;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late AuthenticationService authService;

  late DatabaseService dbService;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockDoc = MockDocumentReference<Map<String, dynamic>>();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);
    dbService = DatabaseService(firestore: mockFirestore);
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    when(
      mockFirebaseAuth.authStateChanges(),
    ).thenAnswer((_) => Stream<User?>.empty());

    authService = AuthenticationService(firebaseAuth: mockFirebaseAuth);

    evaluationModel = EvaluationModel();
    evaluationController = EvaluationController(
      evaluationModel,
      db: dbService,
      authService: authService,
    );
    mockFirebaseAuth = MockFirebaseAuth();

    when(
      mockFirebaseAuth.authStateChanges(),
    ).thenAnswer((_) => Stream<User?>.empty());
  });

  group('EvaluationController', () {
    test('completeTest marca el test como completado', () {
      evaluationController.completeTest('test1');
      expect(evaluationModel.testCompleted['test1'], isTrue);
    });

    test(
      'allTestsCompleted devuelve true si todos los tests están completados',
      () {
        evaluationModel.testCompleted['test1'] = true;
        evaluationModel.testCompleted['test2'] = true;
        evaluationModel.testCompleted['test3'] = true;
        expect(evaluationController.allTestsCompleted(), isTrue);
      },
    );

    test(
      'allTestsCompleted devuelve false si algún test no está completado',
      () {
        evaluationModel.testCompleted['test1'] = true;
        evaluationModel.testCompleted['test2'] = false;
        evaluationModel.testCompleted['test3'] = true;
        expect(evaluationController.allTestsCompleted(), isFalse);
      },
    );
  });
}
