import 'package:breath_bank/models/investment_model.dart';
import 'package:flutter/material.dart';

class InvestmentController {
  final InvestmentModel _model = InvestmentModel();

  Future<bool> guardarInversion({
    required int liston,
    required int resultado,
    required int tiempo,
    required bool exito,
    required String tipoInversion,
  }) {
    return _model.guardarInversion(
      liston: liston,
      resultado: resultado,
      tiempo: tiempo,
      exito: exito,
      tipoInversion: tipoInversion,
    );
  }

  Future<bool> actualizarSaldo(int resultado) {
    return _model.actualizarSaldo(resultado);
  }

  void handleGuardarInversion({
    required BuildContext context,
    required int liston,
    required int resultado,
    required int tiempo,
    required bool exito,
    required String tipoInversion,
  }) async {
    if (await guardarInversion(
      liston: liston,
      resultado: resultado,
      tiempo: tiempo,
      exito: exito,
      tipoInversion: tipoInversion,
    )) {
      if (await actualizarSaldo(resultado)) {
        Navigator.pushNamed(context, '/dashboard');
      } else {
        _showErrorSnackbar(context, 'Error al actualizar el saldo.');
      }
    } else {
      _showErrorSnackbar(context, 'Error al guardar la inversión.');
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
