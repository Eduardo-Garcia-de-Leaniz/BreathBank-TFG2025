import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/models/dashboard_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  Future<void> cerrarSesion(BuildContext context) async {
    final authenticationService = AuthenticationService();
    try {
      await authenticationService.signOut();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesión cerrada con éxito.'),
          backgroundColor: kGreenColor,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al cerrar sesión.'),
          backgroundColor: kRedAccentColor,
        ),
      );
    }
  }
}
