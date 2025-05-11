import 'package:breath_bank/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InvestmentMenuController {
  final DatabaseService db = DatabaseService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> fetchInversiones() async {
    return await db.getUltimasInversiones(userId: userId);
  }

  Future<List<Map<String, dynamic>>> fetchDatosInversiones() async {
    return await db.getUltimasInversiones(userId: userId);
  }

  String formatFecha(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
