import 'package:breath_bank/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InvestmentMenuController {
  final DatabaseService db = DatabaseService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> fetchDatosInversiones() async {
    final inversiones = await db.getUltimasInversiones(userId: userId);

    return inversiones.map((inversion) {
      return {
        'FechaInversión': inversion['FechaInversión'],
        'ListónInversión': inversion['ListónInversión'],
        'ResultadoInversión': inversion['ResultadoInversión'],
        'Superada': inversion['Superada'],
        'TiempoInversión': inversion['TiempoInversión'],
      };
    }).toList();
  }

  String formatFecha(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
