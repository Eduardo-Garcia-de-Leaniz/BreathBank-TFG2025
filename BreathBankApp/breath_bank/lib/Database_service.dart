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
      return snapshot.data()!['Nombre'] as String;
    }
    return null;
  }

  Future<Map<String, String>?> getNombreYApellidosUsuario({
    required String userId,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>>? snapshot = await read(
      collectionPath: 'Usuarios',
      docId: userId,
    );

    if (snapshot != null && snapshot.data() != null) {
      final data = snapshot.data()!;
      return {
        'Nombre': data['Nombre'] as String,
        'Apellidos': data['Apellidos'] as String,
      };
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUsuarioStats({
    required String userId,
  }) async {
    final snapshot = await read(collectionPath: 'Usuarios', docId: userId);

    if (snapshot != null && snapshot.data() != null) {
      final data = snapshot.data()!;

      return {
        'Nombre': data['Nombre'],
        'Apellidos': data['Apellidos'],
        'FechaCreación': data['FechaCreación'],
        'FechaÚltimaEvaluación': data['FechaÚltimaEvaluación'],
        'FechaUltimaInversión': data['FechaUltimaInversión'],
        'NúmeroEvaluacionesRealizadas': data['NúmeroEvaluacionesRealizadas'],
        'NúmeroInversionesRealizadas': data['NúmeroInversionesRealizadas'],
        'NivelInversor': data['NivelInversor'],
        'Saldo': data['Saldo'],
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

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<Map<String, dynamic>?> getResultadosPruebas({
    required String userId,
    required String evaluacionId,
  }) async {
    final snapshot =
        await FirebaseFirestore.instance
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
    final QuerySnapshot<Map<String, dynamic>> snapshot =
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
      data: {'FechaÚltimoAcceso': fechaUltimoAcceso},
    );
  }

  Future<void> updateEvaluacionesRealizadasYNivelInversor({
    required String userId,
    required DateTime fechaUltimaEvaluacion,
    required int nivelInversor,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>>? snapshot = await read(
      collectionPath: 'Usuarios',
      docId: userId,
    );

    if (snapshot != null && snapshot.data() != null) {
      final int numeroEvaluacionesActual =
          snapshot.data()!['NúmeroEvaluacionesRealizadas'] ?? 0;

      await update(
        collectionPath: 'Usuarios',
        docId: userId,
        data: {
          'NúmeroEvaluacionesRealizadas': numeroEvaluacionesActual + 1,
          'FechaÚltimaEvaluación': fechaUltimaEvaluacion,
          'NivelInversor': nivelInversor,
        },
      );
    }
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
      docId: '${userId}_${fechaInversion.toString()}',
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
    required int resultadoPrueba1,
    required int resultadoPrueba2,
    required int resultadoPrueba3,
  }) async {
    final evaluacionId =
        FirebaseFirestore.instance.collection('Evaluaciones').doc().id;

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
    final QuerySnapshot<Map<String, dynamic>> evaluacionesSnapshot =
        await db
            .collection('Evaluaciones')
            .where('IdUsuario', isEqualTo: userId)
            .get();
    for (final doc in evaluacionesSnapshot.docs) {
      final CollectionReference<Map<String, dynamic>> pruebasEvaluacionRef = db
          .collection('Evaluaciones/${doc.id}/PruebasEvaluación');
      final QuerySnapshot<Map<String, dynamic>> pruebasSnapshot =
          await pruebasEvaluacionRef.get();
      for (final pruebaDoc in pruebasSnapshot.docs) {
        await pruebasEvaluacionRef.doc(pruebaDoc.id).delete();
      }

      await db.collection('Evaluaciones').doc(doc.id).delete();
    }

    final QuerySnapshot<Map<String, dynamic>> inversionesSnapshot =
        await db
            .collection('Inversiones')
            .where('IdUsuario', isEqualTo: userId)
            .get();
    for (final doc in inversionesSnapshot.docs) {
      await db.collection('Inversiones').doc(doc.id).delete();
    }

    final DocumentSnapshot<Map<String, dynamic>>? userSnapshot = await read(
      collectionPath: 'Usuarios',
      docId: userId,
    );

    if (userSnapshot != null && userSnapshot.data() != null) {
      final data = userSnapshot.data()!;
      await update(
        collectionPath: 'Usuarios',
        docId: userId,
        data: {
          'Nombre': data['Nombre'],
          'Apellidos': data['Apellidos'],
          'FechaCreación': data['FechaCreación'],
          'FechaÚltimoAcceso': data['FechaÚltimoAcceso'],

          'NivelInversor': 0,
          'NúmeroEvaluacionesRealizadas': 0,
          'NúmeroInversionesRealizadas': 0,
          'FechaÚltimaEvaluación': null,
          'FechaUltimaInversión': null,
          'Saldo': 0,
        },
      );
    }
  }

  Future<void> deleteUserAccount({required String userId}) async {
    final QuerySnapshot<Map<String, dynamic>> evaluacionesSnapshot =
        await db
            .collection('Evaluaciones')
            .where('IdUsuario', isEqualTo: userId)
            .get();
    for (final doc in evaluacionesSnapshot.docs) {
      final CollectionReference<Map<String, dynamic>> pruebasEvaluacionRef = db
          .collection('Evaluaciones/${doc.id}/PruebasEvaluación');
      final QuerySnapshot<Map<String, dynamic>> pruebasSnapshot =
          await pruebasEvaluacionRef.get();
      for (final pruebaDoc in pruebasSnapshot.docs) {
        await pruebasEvaluacionRef.doc(pruebaDoc.id).delete();
      }

      await db.collection('Evaluaciones').doc(doc.id).delete();
    }

    final QuerySnapshot<Map<String, dynamic>> inversionesSnapshot =
        await db
            .collection('Inversiones')
            .where('IdUsuario', isEqualTo: userId)
            .get();
    for (final doc in inversionesSnapshot.docs) {
      await db.collection('Inversiones').doc(doc.id).delete();
    }

    await db.collection('Usuarios').doc(userId).delete();
  }
}
