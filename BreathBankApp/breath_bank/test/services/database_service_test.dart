import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:breath_bank/database_service.dart';
import 'database_service_test.mocks.dart';

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDoc;
  late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshot;
  late DatabaseService dbService;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDoc = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();

    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);

    dbService = DatabaseService(firestore: mockFirestore);
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

  test('updateInversionesYSaldo actualiza inversiones y saldo', () async {
    when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
    when(mockSnapshot.exists).thenReturn(true);
    when(mockSnapshot.data()).thenReturn({kNumeroInversiones: 1, kSaldo: 50});
    when(mockDoc.update(any)).thenAnswer((_) async {});

    await dbService.updateInversionesYSaldo(
      userId: 'user123',
      saldo: 20,
      fechaUltimaInversion: DateTime(2023, 1, 2),
    );

    verify(
      mockDoc.update({
        kNumeroInversiones: 2,
        kSaldo: 70,
        kFechaUltimaInversion: DateTime(2023, 1, 2),
      }),
    ).called(1);
  });

  test('deleteUserData resetea los datos del usuario', () async {
    final mockEvalCollection = MockCollectionReference<Map<String, dynamic>>();
    final mockEvalDoc = MockDocumentReference<Map<String, dynamic>>();
    final mockEvalSnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    final mockEvalDocSnap = MockQueryDocumentSnapshot<Map<String, dynamic>>();
    final mockPruebasCollection =
        MockCollectionReference<Map<String, dynamic>>();
    final mockPruebaDoc = MockDocumentReference<Map<String, dynamic>>();
    final mockPruebasSnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    final mockPruebaDocSnap = MockQueryDocumentSnapshot<Map<String, dynamic>>();
    final mockInvCollection = MockCollectionReference<Map<String, dynamic>>();
    final mockInvSnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    final mockInvDocSnap = MockQueryDocumentSnapshot<Map<String, dynamic>>();

    // Mock evaluaciones
    when(
      mockFirestore.collection('Evaluaciones'),
    ).thenReturn(mockEvalCollection);
    when(
      mockEvalCollection.where('IdUsuario', isEqualTo: anyNamed('isEqualTo')),
    ).thenReturn(mockEvalCollection);
    when(mockEvalCollection.get()).thenAnswer((_) async => mockEvalSnapshot);
    when(mockEvalSnapshot.docs).thenReturn([mockEvalDocSnap]);
    when(mockEvalDocSnap.id).thenReturn('eval1');
    when(
      mockFirestore.collection('Evaluaciones/eval1/PruebasEvaluación'),
    ).thenReturn(mockPruebasCollection);
    when(
      mockPruebasCollection.get(),
    ).thenAnswer((_) async => mockPruebasSnapshot);
    when(mockPruebasSnapshot.docs).thenReturn([mockPruebaDocSnap]);
    when(mockPruebaDocSnap.id).thenReturn('prueba1');
    when(mockPruebasCollection.doc('prueba1')).thenReturn(mockPruebaDoc);
    when(mockPruebaDoc.delete()).thenAnswer((_) async {});
    when(mockEvalCollection.doc('eval1')).thenReturn(mockEvalDoc);
    when(mockEvalDoc.delete()).thenAnswer((_) async {});

    // Mock inversiones
    when(mockFirestore.collection('Inversiones')).thenReturn(mockInvCollection);
    when(
      mockInvCollection.where('IdUsuario', isEqualTo: anyNamed('isEqualTo')),
    ).thenReturn(mockInvCollection);
    when(mockInvCollection.get()).thenAnswer((_) async => mockInvSnapshot);
    when(mockInvSnapshot.docs).thenReturn([mockInvDocSnap]);
    when(mockInvDocSnap.id).thenReturn('inv1');
    when(mockInvCollection.doc('inv1')).thenReturn(mockDoc);
    when(mockDoc.delete()).thenAnswer((_) async {});

    // Mock usuario
    when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
    when(mockSnapshot.exists).thenReturn(true);
    when(mockSnapshot.data()).thenReturn({
      kNombre: 'Carlos',
      kFechaCreacion: DateTime(2023, 1, 1),
      kFechaUltimoAcceso: DateTime(2023, 1, 1),
    });
    when(mockDoc.update(any)).thenAnswer((_) async {});

    await dbService.deleteUserData(userId: 'user123');

    verify(
      mockDoc.update(
        argThat(
          allOf(
            containsPair(kNumeroEvaluaciones, 0),
            containsPair(kSaldo, 0),
            containsPair(kNumeroInversiones, 0),
            containsPair(kNivelInversor, 0),
            containsPair(kFechaUltimaEvaluacion, null),
            containsPair(kFechaUltimaInversion, null),
          ),
        ),
      ),
    ).called(1);
  });

  test('deleteUserAccount elimina usuario y sus datos', () async {
    final mockEvalCollection = MockCollectionReference<Map<String, dynamic>>();
    final mockEvalDoc = MockDocumentReference<Map<String, dynamic>>();
    final mockEvalSnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    final mockEvalDocSnap = MockQueryDocumentSnapshot<Map<String, dynamic>>();
    final mockPruebasCollection =
        MockCollectionReference<Map<String, dynamic>>();
    final mockPruebasSnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    final mockPruebaDocSnap = MockQueryDocumentSnapshot<Map<String, dynamic>>();
    final mockPruebaDoc = MockDocumentReference<Map<String, dynamic>>();
    final mockInvCollection = MockCollectionReference<Map<String, dynamic>>();
    final mockInvSnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    final mockInvDocSnap = MockQueryDocumentSnapshot<Map<String, dynamic>>();
    final mockUserDoc = MockDocumentReference<Map<String, dynamic>>();

    // Mock evaluaciones
    when(
      mockFirestore.collection('Evaluaciones'),
    ).thenReturn(mockEvalCollection);
    when(
      mockEvalCollection.where('IdUsuario', isEqualTo: anyNamed('isEqualTo')),
    ).thenReturn(mockEvalCollection);
    when(mockEvalCollection.get()).thenAnswer((_) async => mockEvalSnapshot);
    when(mockEvalSnapshot.docs).thenReturn([mockEvalDocSnap]);
    when(mockEvalDocSnap.id).thenReturn('eval1');
    when(
      mockFirestore.collection('Evaluaciones/eval1/PruebasEvaluación'),
    ).thenReturn(mockPruebasCollection);
    when(
      mockPruebasCollection.get(),
    ).thenAnswer((_) async => mockPruebasSnapshot);
    when(mockPruebasSnapshot.docs).thenReturn([mockPruebaDocSnap]);
    when(mockPruebaDocSnap.id).thenReturn('prueba1');
    when(mockPruebasCollection.doc('prueba1')).thenReturn(mockPruebaDoc);
    when(mockPruebaDoc.delete()).thenAnswer((_) async {});
    when(mockEvalCollection.doc('eval1')).thenReturn(mockEvalDoc);
    when(mockEvalDoc.delete()).thenAnswer((_) async {});

    // Mock inversiones
    when(mockFirestore.collection('Inversiones')).thenReturn(mockInvCollection);
    when(
      mockInvCollection.where('IdUsuario', isEqualTo: anyNamed('isEqualTo')),
    ).thenReturn(mockInvCollection);
    when(mockInvCollection.get()).thenAnswer((_) async => mockInvSnapshot);
    when(mockInvSnapshot.docs).thenReturn([mockInvDocSnap]);
    when(mockInvDocSnap.id).thenReturn('inv1');
    when(mockInvCollection.doc('inv1')).thenReturn(mockDoc);
    when(mockDoc.delete()).thenAnswer((_) async {});

    // Mock usuario
    when(mockFirestore.collection('Usuarios')).thenReturn(mockCollection);
    when(mockCollection.doc('user123')).thenReturn(mockUserDoc);
    when(mockUserDoc.delete()).thenAnswer((_) async {});

    await dbService.deleteUserAccount(userId: 'user123');

    verify(mockUserDoc.delete()).called(1);
  });
}
