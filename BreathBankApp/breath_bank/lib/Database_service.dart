import 'package:cloud_firestore/cloud_firestore.dart';

class Database_service {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> create({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await db.collection(collectionPath).doc(docId).set(data);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> read({
    required String collectionPath,
    required String docId,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await db.collection(collectionPath).doc(docId).get();
    return snapshot.exists ? snapshot : null;
  }

  Future<void> update({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await db.collection(collectionPath).doc(docId).update(data);
  }

  Future<void> delete({
    required String collectionPath,
    required String docId,
  }) async {
    await db.collection(collectionPath).doc(docId).delete();
  }

  Future<void> addNewUser({
    required String userId,
    required String nombre,
    required String apellidos,
    required DateTime fechaCreacion,
  }) async {
    await create(
      collectionPath: 'Usuarios',
      docId: userId,
      data: {
        'Nombre': nombre,
        'Apellidos': apellidos,
        'FechaCreación': fechaCreacion,
        'FechaÚltimoAcceso': fechaCreacion,
        'FechaÚltimaEvaluación': fechaCreacion,
        'FechaUltimaInversión': fechaCreacion,
        'NivelInversor': 0,
        'NúmeroEvaluacionesRealizadas': 0,
        'NúmeroInversionesRealizadas': 0,
        'Saldo': 0,
      },
    );
  }

  Future<String?> getNombreUsuario({required String userId}) async {
    final DocumentSnapshot<Map<String, dynamic>>? snapshot = await read(
      collectionPath: 'Usuarios',
      docId: userId,
    );

    if (snapshot != null && snapshot.data() != null) {
      print(snapshot.data()!['Nombre'] as String); // Depuración
      return snapshot.data()!['Nombre'] as String;
    }
    return null;
  }

  Future<void> updateFechaUltimoAcceso({
    required String userId,
    required DateTime fechaUltimoAcceso,
  }) async {
    await update(
      collectionPath: 'Usuarios',
      docId: userId,
      data: {'FechaÚltimoAcceso': fechaUltimoAcceso},
    );
  }

  Future<void> updateEvaluacionesRealizadas({
    required String userId,
    required int numeroEvaluaciones,
    required DateTime fechaUltimaEvaluacion,
  }) async {
    await update(
      collectionPath: 'Usuarios',
      docId: userId,
      data: {
        'NúmeroEvaluacionesRealizadas': numeroEvaluaciones,
        'FechaÚltimaEvaluación': fechaUltimaEvaluacion,
      },
    );
  }

  Future<void> updateInversionesYSaldo({
    required String userId,
    required int numeroInversiones,
    required double saldo,
    required DateTime fechaUltimaInversion,
  }) async {
    await update(
      collectionPath: 'Usuarios',
      docId: userId,
      data: {
        'NúmeroInversionesRealizadas': numeroInversiones,
        'Saldo': saldo,
        'FechaUltimaInversión': fechaUltimaInversion,
      },
    );
  }

  Future<void> updateNombreYApellidos({
    required String userId,
    required String nombre,
    required String apellidos,
  }) async {
    await update(
      collectionPath: 'Usuarios',
      docId: userId,
      data: {'Nombre': nombre, 'Apellidos': apellidos},
    );
  }

  Future<void> addNuevaInversion({
    required String userId,
    required DateTime fechaInversion,
    required double listonInversion,
    required String resultadoInversion,
  }) async {
    await create(
      collectionPath: 'Inversiones',
      docId: '${userId}_${fechaInversion.toIso8601String()}',
      data: {
        'IdUsuario': userId,
        'FechaInversión': fechaInversion,
        'ListónInversión': listonInversion,
        'ResultadoInversión': resultadoInversion,
      },
    );
  }

  Future<void> addNuevaEvaluacion({
    required String userId,
    required DateTime fechaEvaluacion,
    required int nivelInversorFinal,
    required double resultadoPrueba1,
    required double resultadoPrueba2,
    required double resultadoPrueba3,
  }) async {
    final String evaluacionId =
        '${userId}_${fechaEvaluacion.toIso8601String()}'; // Revisar Id de la evaluación

    await create(
      collectionPath: 'Evaluaciones',
      docId: evaluacionId,
      data: {
        'IdUsuario': userId,
        'Fecha': fechaEvaluacion,
        'NivelInversorFinal': nivelInversorFinal,
      },
    );

    await create(
      collectionPath: 'Evaluaciones/$evaluacionId/PruebasEvaluación',
      docId: 'Resultados',
      data: {
        'ResultadoPrueba1': resultadoPrueba1,
        'ResultadoPrueba2': resultadoPrueba2,
        'ResultadoPrueba3': resultadoPrueba3,
      },
    );
  }
}
