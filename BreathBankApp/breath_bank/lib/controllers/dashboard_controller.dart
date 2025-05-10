import 'package:breath_bank/models/dashboard_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardController {
  final DashboardModel _model = DashboardModel();

  Future<Map<String, dynamic>?> fetchUsuarioStats() {
    return _model.getUsuarioStats();
  }

  Future<String?> fetchNombreUsuario() {
    return _model.getNombreUsuario();
  }

  Future<List<Map<String, dynamic>>> fetchUltimasInversiones() {
    return _model.getUltimasInversiones();
  }

  Future<List<Map<String, dynamic>>> fetchUltimasEvaluaciones() {
    return _model.getUltimasEvaluaciones();
  }

  String formatFecha(Timestamp timestamp) {
    final date = timestamp.toDate();
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
