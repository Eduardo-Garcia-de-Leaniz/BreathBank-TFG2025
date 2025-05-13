import 'package:breath_bank/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InvestmentModel {
  final DatabaseService _db = DatabaseService();
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  Future<bool> guardarInversion({
    required int liston,
    required int resultado,
    required int tiempo,
    required bool exito,
    required String tipoInversion,
  }) async {
    try {
      await _db.addNuevaInversion(
        userId: _userId,
        fechaInversion: DateTime.now(),
        listonInversion: liston,
        resultadoInversion: resultado,
        tiempoInversion: tiempo,
        superada: exito,
        tipoInversion: tipoInversion,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> actualizarSaldo(int resultado) async {
    try {
      await _db.updateInversionesYSaldo(
        userId: _userId,
        saldo: resultado,
        fechaUltimaInversion: DateTime.now(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
