import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:breath_bank/database_service.dart';

class DashboardModel {
  final DatabaseService _db = DatabaseService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, dynamic>?> getUsuarioStats() async {
    return await _db.getUsuarioStats(userId: userId);
  }

  Future<String?> getNombreUsuario() async {
    return await _db.getNombreUsuario(userId: userId);
  }

  Future<List<Map<String, dynamic>>> getUltimasInversiones() async {
    return await _db.getUltimasInversiones(userId: userId);
  }

  Future<List<Map<String, dynamic>>> getUltimasEvaluaciones() async {
    return await _db.getUltimasEvaluaciones(userId: userId);
  }
}
