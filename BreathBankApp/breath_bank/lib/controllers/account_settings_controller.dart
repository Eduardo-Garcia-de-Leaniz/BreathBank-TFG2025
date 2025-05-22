import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const String noDisponible = 'No disponible';

class AccountSettingsController {
  final DatabaseService db = DatabaseService();
  final AuthenticationService authenticationService = AuthenticationService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, String>> cargarDatosUsuario() async {
    final userDoc = await db.read(collectionPath: 'Usuarios', docId: userId);
    final nombre = userDoc?['Nombre'] ?? noDisponible;
    final email = FirebaseAuth.instance.currentUser?.email ?? noDisponible;
    return {'nombre': nombre, 'email': email};
  }

  Future<void> borrarHistorial(BuildContext context) async {
    try {
      await db.deleteUserData(userId: userId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Historial borrado con éxito.'),
          backgroundColor: kGreenColor,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al borrar el historial.'),
          backgroundColor: kRedAccentColor,
        ),
      );
    }
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

  Future<void> eliminarCuenta({
    required String password,
    required BuildContext context,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      await db.deleteUserAccount(userId: user!.uid);
      await AuthenticationService().deleteAccount(
        email: user.email!,
        password: password,
      );
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
          content: Text('Error al eliminar la cuenta.'),
          backgroundColor: kRedAccentColor,
        ),
      );
    }
  }

  Future<Map<String, dynamic>?> getUsuarioStats() async {
    return await db.getUsuarioStats(userId: userId);
  }

  Future<void> updateNombreYApellidos({required String nombre}) async {
    await db.updateNombreYApellidos(userId: userId, nombre: nombre);
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    await authenticationService.resetPasswordFromCurrentPassword(
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
