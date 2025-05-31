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
}
