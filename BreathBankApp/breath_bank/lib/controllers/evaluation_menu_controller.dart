import 'package:breath_bank/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EvaluationMenuController {
  final DatabaseService db = DatabaseService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> fetchEvaluaciones() async {
    return await db.getUltimasEvaluaciones(userId: userId);
  }

  String formatFecha(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<List<Map<String, dynamic>>> fetchDatosEstadisticos() async {
    List<Map<String, dynamic>> datos = [];

    final evaluaciones = await db.getUltimasEvaluaciones(userId: userId);

    for (var evaluacion in evaluaciones) {
      final evaluacionId = evaluacion['id'];
      final nivelInversor = evaluacion['NivelInversorFinal'];

      final resultados = await db.getResultadosPruebas(
        userId: userId,
        evaluacionId: evaluacionId,
      );

      if (resultados != null && resultados.isNotEmpty) {
        // Recolectamos los resultados exactamente igual que en historial
        final prueba1 =
            resultados.containsKey('ResultadoPrueba1')
                ? resultados['ResultadoPrueba1']
                : null;
        final prueba2 =
            resultados.containsKey('ResultadoPrueba2')
                ? resultados['ResultadoPrueba2']
                : null;
        final prueba3 =
            resultados.containsKey('ResultadoPrueba3')
                ? resultados['ResultadoPrueba3']
                : null;

        datos.add({
          'nivel': nivelInversor,
          'prueba1': prueba1,
          'prueba2': prueba2,
          'prueba3': prueba3,
        });
      }
    }

    return datos;
  }

  Future<Map<String, dynamic>?> fetchResultadosPruebas(
    String evaluacionId,
  ) async {
    return await db.getResultadosPruebas(
      userId: userId,
      evaluacionId: evaluacionId,
    );
  }
}
