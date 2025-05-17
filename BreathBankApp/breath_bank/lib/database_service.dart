import 'package:cloud_firestore/cloud_firestore.dart';

// Constantes para los campos de usuario
const String kFechaCreacion = 'FechaCreación';
const String kFechaUltimoAcceso = 'FechaÚltimoAcceso';
const String kFechaUltimaEvaluacion = 'FechaÚltimaEvaluación';
const String kFechaUltimaInversion = 'FechaUltimaInversión';
const String kNivelInversor = 'NivelInversor';
const String kNumeroEvaluaciones = 'NúmeroEvaluacionesRealizadas';
const String kNumeroInversiones = 'NúmeroInversionesRealizadas';
const String kSaldo = 'Saldo';
const String kNombre = 'Nombre';

class DatabaseService {
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
    required DateTime fechaCreacion,
  }) async {
    await create(
      collectionPath: 'Usuarios',
      docId: userId,
      data: {
        kNombre: nombre,
        kFechaCreacion: fechaCreacion,
        kFechaUltimoAcceso: fechaCreacion,
        kFechaUltimaEvaluacion: null,
        kFechaUltimaInversion: null,
        kNivelInversor: 0,
        kNumeroEvaluaciones: 0,
        kNumeroInversiones: 0,
        kSaldo: 0,
      },
    );
  }

  Future<String?> getNombreUsuario({required String userId}) async {
    final snapshot = await read(collectionPath: 'Usuarios', docId: userId);
    if (snapshot != null && snapshot.data() != null) {
      return snapshot.data()![kNombre] as String;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUsuarioStats({
    required String userId,
  }) async {
    final snapshot = await read(collectionPath: 'Usuarios', docId: userId);
    if (snapshot != null && snapshot.data() != null) {
      final data = snapshot.data()!;
      print('saldoBD: ${data[kSaldo]}');
      return {
        kNombre: data[kNombre],
        kFechaCreacion: data[kFechaCreacion],
        kFechaUltimaEvaluacion: data[kFechaUltimaEvaluacion],
        kFechaUltimaInversion: data[kFechaUltimaInversion],
        kNumeroEvaluaciones: data[kNumeroEvaluaciones],
        kNumeroInversiones: data[kNumeroInversiones],
        kNivelInversor: data[kNivelInversor],
        kSaldo:
            (data[kSaldo] is int)
                ? data[kSaldo]
                : (data[kSaldo] as num).toInt(),
      };
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getUltimasEvaluaciones({
    required String userId,
  }) async {
    final snapshot =
        await db
            .collection('Evaluaciones')
            .where('IdUsuario', isEqualTo: userId)
            .get();

    final evaluaciones =
        snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();

    evaluaciones.sort((a, b) {
      final fechaA = a['Fecha'] as Timestamp?;
      final fechaB = b['Fecha'] as Timestamp?;
      return fechaA!.compareTo(fechaB!);
    });

    return evaluaciones;
  }

  Future<Map<String, dynamic>?> getResultadosPruebas({
    required String userId,
    required String evaluacionId,
  }) async {
    final snapshot =
        await db
            .collection('Evaluaciones/$evaluacionId/PruebasEvaluación')
            .doc('Resultados')
            .get();

    if (snapshot.exists && snapshot.data() != null) {
      final data = snapshot.data()!;
      return {
        'ResultadoPrueba1': data['ResultadoPrueba1'],
        'ResultadoPrueba2': data['ResultadoPrueba2'],
        'ResultadoPrueba3': data['ResultadoPrueba3'],
      };
    }

    return snapshot.exists ? snapshot.data() : null;
  }

  Future<List<Map<String, dynamic>>> getUltimasInversiones({
    required String userId,
  }) async {
    final snapshot =
        await db
            .collection('Inversiones')
            .where('IdUsuario', isEqualTo: userId)
            .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> updateFechaUltimoAcceso({
    required String userId,
    required DateTime fechaUltimoAcceso,
  }) async {
    await update(
      collectionPath: 'Usuarios',
      docId: userId,
      data: {kFechaUltimoAcceso: fechaUltimoAcceso},
    );
  }

  Future<void> updateEvaluacionesRealizadasYNivelInversor({
    required String userId,
    required DateTime fechaUltimaEvaluacion,
    required int nivelInversor,
  }) async {
    final snapshot = await read(collectionPath: 'Usuarios', docId: userId);
    if (snapshot != null && snapshot.data() != null) {
      final int evaluacionesActuales =
          snapshot.data()![kNumeroEvaluaciones] ?? 0;

      await update(
        collectionPath: 'Usuarios',
        docId: userId,
        data: {
          kNumeroEvaluaciones: evaluacionesActuales + 1,
          kFechaUltimaEvaluacion: fechaUltimaEvaluacion,
          kNivelInversor: nivelInversor,
        },
      );
    }
  }

  Future<void> updateInversionesYSaldo({
    required String userId,
    required int saldo,
    required DateTime fechaUltimaInversion,
  }) async {
    final snapshot = await read(collectionPath: 'Usuarios', docId: userId);
    if (snapshot != null && snapshot.data() != null) {
      final int numeroInversionesActuales =
          (snapshot.data()![kNumeroInversiones] is int)
              ? snapshot.data()![kNumeroInversiones]
              : (snapshot.data()![kNumeroInversiones] as num?)?.toInt() ?? 0;

      final int saldoActual =
          (snapshot.data()![kSaldo] is int)
              ? snapshot.data()![kSaldo]
              : (snapshot.data()![kSaldo] as num?)?.toInt() ?? 0;
      await update(
        collectionPath: 'Usuarios',
        docId: userId,
        data: {
          kNumeroInversiones: numeroInversionesActuales + 1,
          kSaldo: saldoActual + saldo,
          kFechaUltimaInversion: fechaUltimaInversion,
        },
      );
    }
  }

  Future<void> updateNombreYApellidos({
    required String userId,
    required String nombre,
  }) async {
    await update(
      collectionPath: 'Usuarios',
      docId: userId,
      data: {kNombre: nombre},
    );
  }

  Future<void> addNuevaInversion({
    required String userId,
    required DateTime fechaInversion,
    required int listonInversion,
    required int resultadoInversion,
    required int tiempoInversion,
    required bool superada,
    required String tipoInversion,
  }) async {
    await create(
      collectionPath: 'Inversiones',
      docId: '${userId}_${fechaInversion.toString()}',
      data: {
        'IdUsuario': userId,
        'FechaInversión': fechaInversion,
        'ListónInversión': listonInversion,
        'ResultadoInversión': resultadoInversion,
        'TiempoInversión': tiempoInversion,
        'Superada': superada,
        'TipoInversión': tipoInversion,
      },
    );
  }

  Future<void> addNuevaEvaluacion({
    required String userId,
    required DateTime fechaEvaluacion,
    required int nivelInversorFinal,
    required int resultadoPrueba1,
    required int resultadoPrueba2,
    required int resultadoPrueba3,
  }) async {
    final evaluacionId = db.collection('Evaluaciones').doc().id;

    await create(
      collectionPath: 'Evaluaciones',
      docId: evaluacionId,
      data: {
        'IdUsuario': userId,
        'Fecha': fechaEvaluacion,
        'NivelInversorFinal': nivelInversorFinal,
        'EvaluacionId': evaluacionId,
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

  Future<String?> getUltimaEvaluacionIdDelUsuario(String userId) async {
    final snapshot =
        await db
            .collection('Evaluaciones')
            .where('IdUsuario', isEqualTo: userId)
            .orderBy('Fecha', descending: true)
            .limit(1)
            .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }

  Future<void> deleteUserData({required String userId}) async {
    final evaluacionesSnapshot =
        await db
            .collection('Evaluaciones')
            .where('IdUsuario', isEqualTo: userId)
            .get();

    for (final doc in evaluacionesSnapshot.docs) {
      final pruebasRef = db.collection(
        'Evaluaciones/${doc.id}/PruebasEvaluación',
      );
      final pruebasSnapshot = await pruebasRef.get();
      for (final pruebaDoc in pruebasSnapshot.docs) {
        await pruebasRef.doc(pruebaDoc.id).delete();
      }
      await db.collection('Evaluaciones').doc(doc.id).delete();
    }

    final inversionesSnapshot =
        await db
            .collection('Inversiones')
            .where('IdUsuario', isEqualTo: userId)
            .get();

    for (final doc in inversionesSnapshot.docs) {
      await db.collection('Inversiones').doc(doc.id).delete();
    }

    final userSnapshot = await read(collectionPath: 'Usuarios', docId: userId);
    if (userSnapshot != null && userSnapshot.data() != null) {
      final data = userSnapshot.data()!;
      await update(
        collectionPath: 'Usuarios',
        docId: userId,
        data: {
          kNombre: data[kNombre],
          kFechaCreacion: data[kFechaCreacion],
          kFechaUltimoAcceso: data[kFechaUltimoAcceso],
          kNivelInversor: 0,
          kNumeroEvaluaciones: 0,
          kNumeroInversiones: 0,
          kFechaUltimaEvaluacion: null,
          kFechaUltimaInversion: null,
          kSaldo: 0,
        },
      );
    }
  }

  Future<void> deleteUserAccount({required String userId}) async {
    final evaluacionesSnapshot =
        await db
            .collection('Evaluaciones')
            .where('IdUsuario', isEqualTo: userId)
            .get();

    for (final doc in evaluacionesSnapshot.docs) {
      final pruebasRef = db.collection(
        'Evaluaciones/${doc.id}/PruebasEvaluación',
      );
      final pruebasSnapshot = await pruebasRef.get();
      for (final pruebaDoc in pruebasSnapshot.docs) {
        await pruebasRef.doc(pruebaDoc.id).delete();
      }
      await db.collection('Evaluaciones').doc(doc.id).delete();
    }

    final inversionesSnapshot =
        await db
            .collection('Inversiones')
            .where('IdUsuario', isEqualTo: userId)
            .get();

    for (final doc in inversionesSnapshot.docs) {
      await db.collection('Inversiones').doc(doc.id).delete();
    }

    await db.collection('Usuarios').doc(userId).delete();
  }

  Future<void> deleteInvestments({required String userId}) async {
    final inversionesSnapshot =
        await db
            .collection('Inversiones')
            .where('IdUsuario', isEqualTo: userId)
            .get();

    for (final doc in inversionesSnapshot.docs) {
      await db.collection('Inversiones').doc(doc.id).delete();
    }

    // Reset user's investment-related fields in 'Usuarios' collection
    final userSnapshot = await read(collectionPath: 'Usuarios', docId: userId);
    if (userSnapshot != null && userSnapshot.data() != null) {
      final data = userSnapshot.data()!;
      await update(
        collectionPath: 'Usuarios',
        docId: userId,
        data: {
          kNumeroInversiones: 0,
          kSaldo: 0,
          kFechaUltimaInversion: null,
          // Keep other fields unchanged
          kNombre: data[kNombre],
          kFechaCreacion: data[kFechaCreacion],
          kFechaUltimoAcceso: data[kFechaUltimoAcceso],
          kNivelInversor: data[kNivelInversor],
          kNumeroEvaluaciones: data[kNumeroEvaluaciones],
          kFechaUltimaEvaluacion: data[kFechaUltimaEvaluacion],
        },
      );
    }
  }
}
