import 'package:breath_bank/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewInvestmentMenuModel {
  final DatabaseService _db = DatabaseService();
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, dynamic>> fetchUserStats() async {
    final stats = await _db.getUsuarioStats(userId: _userId);
    final nivelInversor = stats?['NivelInversor'] ?? 0;
    final saldo = stats?['Saldo'] ?? 0;

    final rangos = _calcularRangos(nivelInversor);

    return {
      'nivelInversor': nivelInversor,
      'saldo': saldo,
      'rangoInferior': rangos['rangoInferior'],
      'rangoSuperior': rangos['rangoSuperior'],
    };
  }

  Map<String, int> _calcularRangos(int nivelInversor) {
    int rangoInferior = 2;
    int rangoSuperior = 8;

    if (nivelInversor > 1) {
      rangoInferior = (nivelInversor - 1) * 10;
      rangoSuperior = rangoInferior + 8;
    }

    return {'rangoInferior': rangoInferior, 'rangoSuperior': rangoSuperior};
  }
}
