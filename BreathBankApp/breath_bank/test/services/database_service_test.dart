import 'package:breath_bank/controllers/investment_controller.dart';
import 'package:breath_bank/controllers/login_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:breath_bank/database_service.dart';
import 'database_service_test.mocks.dart';

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDoc;
  late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshot;
  late DatabaseService dbService;
  late LoginController loginController;
  late InvestmentController investmentController;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDoc = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();

    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);

    dbService = DatabaseService(firestore: mockFirestore);
    loginController = LoginController(db: dbService);
  });

  test('create llama a set en el documento', () async {
    when(mockDoc.set(any)).thenAnswer((_) async {});
    await dbService.create(
      collectionPath: 'Usuarios',
      docId: 'user123',
      data: {'Nombre': 'Test'},
    );
    verify(mockDoc.set({'Nombre': 'Test'})).called(1);
  });

  test('getNombreUsuario llama a getNombreUsuario en el controlador', () async {
    when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
    when(mockSnapshot.exists).thenReturn(true);
    when(mockSnapshot.data()).thenReturn({'Nombre': 'Carlos'});

    final nombre = await loginController.getNombreUsuario('user123');

    expect(nombre, 'Carlos');
  });

  test('read devuelve null si el snapshot no existe', () async {
    when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
    when(mockSnapshot.exists).thenReturn(false);

    final result = await dbService.read(
      collectionPath: 'Usuarios',
      docId: 'user123',
    );

    expect(result, isNull);
    verify(mockDoc.get()).called(1);
  });

  test('read devuelve el snapshot si existe', () async {
    when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
    when(mockSnapshot.exists).thenReturn(true);

    final result = await dbService.read(
      collectionPath: 'Usuarios',
      docId: 'user123',
    );

    expect(result, mockSnapshot);
    verify(mockDoc.get()).called(1);
  });

  test('update llama a update en el documento', () async {
    when(mockDoc.update(any)).thenAnswer((_) async {});

    await dbService.update(
      collectionPath: 'Usuarios',
      docId: 'user123',
      data: {'Nombre': 'NuevoNombre'},
    );

    verify(mockDoc.update({'Nombre': 'NuevoNombre'})).called(1);
  });

  test('delete llama a delete en el documento', () async {
    when(mockDoc.delete()).thenAnswer((_) async {});

    await dbService.delete(collectionPath: 'Usuarios', docId: 'user123');

    verify(mockDoc.delete()).called(1);
  });

  test('getNombreUsuario devuelve el nombre si existe', () async {
    when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
    when(mockSnapshot.exists).thenReturn(true);
    when(mockSnapshot.data()).thenReturn({'Nombre': 'Carlos'});

    final nombre = await dbService.getNombreUsuario(userId: 'user123');

    expect(nombre, 'Carlos');
  });

  test(
    'addNewUser crea un documento de usuario con campos iniciales',
    () async {
      when(mockDoc.set(any)).thenAnswer((_) async {});
      final fecha = DateTime(2023, 1, 1);

      await dbService.addNewUser(
        userId: 'user123',
        nombre: 'Carlos',
        fechaCreacion: fecha,
      );

      verify(
        mockDoc.set({
          kNombre: 'Carlos',
          kFechaCreacion: fecha,
          kFechaUltimoAcceso: fecha,
          kFechaUltimaEvaluacion: null,
          kFechaUltimaInversion: null,
          kNivelInversor: 0,
          kNumeroEvaluaciones: 0,
          kNumeroInversiones: 0,
          kSaldo: 0,
        }),
      ).called(1);
    },
  );

  test('updateNombreYApellidos actualiza el nombre del usuario', () async {
    when(mockDoc.update(any)).thenAnswer((_) async {});

    await dbService.updateNombreYApellidos(
      userId: 'user123',
      nombre: 'Nuevo Nombre',
    );

    verify(mockDoc.update({kNombre: 'Nuevo Nombre'})).called(1);
  });

  test('updateFechaUltimoAcceso actualiza la fecha de último acceso', () async {
    when(mockDoc.update(any)).thenAnswer((_) async {});

    await dbService.updateFechaUltimoAcceso(
      userId: 'user123',
      fechaUltimoAcceso: DateTime(2023, 1, 1),
    );

    verify(
      mockDoc.update({kFechaUltimoAcceso: DateTime(2023, 1, 1)}),
    ).called(1);
  });

  test(
    'getUsuarioStats devuelve el mapa de estadísticas del usuario',
    () async {
      when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.data()).thenReturn({
        kNombre: 'Carlos',
        kFechaCreacion: DateTime(2023, 1, 1),
        kFechaUltimaEvaluacion: null,
        kFechaUltimaInversion: null,
        kNumeroEvaluaciones: 2,
        kNumeroInversiones: 1,
        kNivelInversor: 3,
        kSaldo: 100,
      });

      final stats = await dbService.getUsuarioStats(userId: 'user123');

      expect(stats, isNotNull);
      expect(stats![kNombre], 'Carlos');
      expect(stats[kNumeroEvaluaciones], 2);
      expect(stats[kSaldo], 100);
    },
  );

  test('getNombreUsuario devuelve null si snapshot no existe', () async {
    when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
    when(mockSnapshot.exists).thenReturn(false);

    final nombre = await dbService.getNombreUsuario(userId: 'user123');

    expect(nombre, isNull);
  });

  test('delete llama a delete en el documento correcto', () async {
    when(mockDoc.delete()).thenAnswer((_) async {});
    await dbService.delete(collectionPath: 'Usuarios', docId: 'user123');
    verify(mockDoc.delete()).called(1);
  });

  // Ejemplo de test para el LoginController usando el DatabaseService mockeado
  test('LoginController llama a getNombreUsuario al obtener nombre', () async {
    when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
    when(mockSnapshot.exists).thenReturn(true);
    when(mockSnapshot.data()).thenReturn({'Nombre': 'Carlos'});

    final nombre = await loginController.getNombreUsuario('user123');

    expect(nombre, 'Carlos');
  });

  test('getResultadosPruebas devuelve resultados si existen', () async {
    final mockPruebasCollection =
        MockCollectionReference<Map<String, dynamic>>();
    final mockResultadosDoc = MockDocumentReference<Map<String, dynamic>>();
    final mockResultadosSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

    when(
      mockFirestore.collection('Evaluaciones/eval123/PruebasEvaluación'),
    ).thenReturn(mockPruebasCollection);
    when(mockPruebasCollection.doc('Resultados')).thenReturn(mockResultadosDoc);
    when(
      mockResultadosDoc.get(),
    ).thenAnswer((_) async => mockResultadosSnapshot);
    when(mockResultadosSnapshot.exists).thenReturn(true);
    when(mockResultadosSnapshot.data()).thenReturn({
      'ResultadoPrueba1': 10,
      'ResultadoPrueba2': 20,
      'ResultadoPrueba3': 30,
    });

    final result = await dbService.getResultadosPruebas(
      userId: 'user123',
      evaluacionId: 'eval123',
    );
    expect(result, isNotNull);
    expect(result!['ResultadoPrueba1'], 10);
  });

  test(
    'updateEvaluacionesRealizadasYNivelInversor actualiza campos correctamente',
    () async {
      when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.data()).thenReturn({kNumeroEvaluaciones: 2});
      when(mockDoc.update(any)).thenAnswer((_) async {});

      await dbService.updateEvaluacionesRealizadasYNivelInversor(
        userId: 'user123',
        fechaUltimaEvaluacion: DateTime(2023, 1, 1),
        nivelInversor: 3,
      );

      verify(
        mockDoc.update(argThat(containsPair(kNumeroEvaluaciones, 3))),
      ).called(1);
    },
  );

  test('addNuevaInversion llama a create con los datos correctos', () async {
    when(mockDoc.set(any)).thenAnswer((_) async {});
    await dbService.addNuevaInversion(
      userId: 'user123',
      fechaInversion: DateTime(2023, 1, 1),
      listonInversion: 10,
      resultadoInversion: 20,
      tiempoInversion: 30,
      superada: true,
      tipoInversion: 'tipo',
    );
    verify(
      mockDoc.set(argThat(containsPair('IdUsuario', 'user123'))),
    ).called(1);
  });

  test(
    'addNuevaEvaluacion llama a create para evaluación y resultados',
    () async {
      final mockEvaluacionesCollection =
          MockCollectionReference<Map<String, dynamic>>();
      final mockPruebasCollection =
          MockCollectionReference<Map<String, dynamic>>();
      final mockEvaluacionDoc = MockDocumentReference<Map<String, dynamic>>();

      when(
        mockFirestore.collection('Evaluaciones'),
      ).thenReturn(mockEvaluacionesCollection);
      when(mockEvaluacionesCollection.doc()).thenReturn(mockEvaluacionDoc);
      when(
        mockEvaluacionesCollection.doc('evalId'),
      ).thenReturn(mockEvaluacionDoc);
      when(mockEvaluacionDoc.id).thenReturn('evalId');
      when(mockEvaluacionDoc.set(any)).thenAnswer((_) async {});
      when(
        mockFirestore.collection('Evaluaciones/evalId/PruebasEvaluación'),
      ).thenReturn(mockPruebasCollection);
      when(mockPruebasCollection.doc('Resultados')).thenReturn(mockDoc);
      when(mockDoc.set(any)).thenAnswer((_) async {});

      await dbService.addNuevaEvaluacion(
        userId: 'user123',
        fechaEvaluacion: DateTime(2023, 1, 1),
        nivelInversorFinal: 2,
        resultadoPrueba1: 10,
        resultadoPrueba2: 20,
        resultadoPrueba3: 30,
      );

      verify(
        mockEvaluacionDoc.set(argThat(containsPair('IdUsuario', 'user123'))),
      ).called(1);
      verify(
        mockDoc.set(argThat(containsPair('ResultadoPrueba1', 10))),
      ).called(1);
    },
  );

  test(
    'getUltimaEvaluacionIdDelUsuario devuelve null si no hay evaluaciones',
    () async {
      final mockQuery = MockQuery<Map<String, dynamic>>();
      final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();

      when(mockFirestore.collection('Evaluaciones')).thenReturn(mockCollection);
      when(
        mockCollection.where('IdUsuario', isEqualTo: anyNamed('isEqualTo')),
      ).thenReturn(mockQuery);
      when(mockQuery.orderBy('Fecha', descending: true)).thenReturn(mockQuery);
      when(mockQuery.limit(1)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([]);

      final result = await dbService.getUltimaEvaluacionIdDelUsuario('user123');
      expect(result, isNull);
    },
  );

  // ...existing code...

  test('getResultadosPruebas devuelve resultados si existen', () async {
    final mockPruebasCollection =
        MockCollectionReference<Map<String, dynamic>>();
    final mockResultadosDoc = MockDocumentReference<Map<String, dynamic>>();
    final mockResultadosSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

    when(
      mockFirestore.collection('Evaluaciones/eval123/PruebasEvaluación'),
    ).thenReturn(mockPruebasCollection);
    when(mockPruebasCollection.doc('Resultados')).thenReturn(mockResultadosDoc);
    when(
      mockResultadosDoc.get(),
    ).thenAnswer((_) async => mockResultadosSnapshot);
    when(mockResultadosSnapshot.exists).thenReturn(true);
    when(mockResultadosSnapshot.data()).thenReturn({
      'ResultadoPrueba1': 10,
      'ResultadoPrueba2': 20,
      'ResultadoPrueba3': 30,
    });

    final result = await dbService.getResultadosPruebas(
      userId: 'user123',
      evaluacionId: 'eval123',
    );
    expect(result, isNotNull);
    expect(result!['ResultadoPrueba1'], 10);
  });

  // Para deleteUserData, deleteUserAccount y deleteInvestments se recomienda usar mocks avanzados y verificar llamadas a delete/update según la lógica de tu app.
}
