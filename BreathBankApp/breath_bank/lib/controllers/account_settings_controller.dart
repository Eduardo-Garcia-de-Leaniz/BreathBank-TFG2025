import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> borrarHistorial() async {
    await db.deleteUserData(userId: userId);
  }

  Future<void> cerrarSesion() async {
    final authenticationService = AuthenticationService();
    await authenticationService.signOut();
  }

  Future<void> eliminarCuenta({
    required String password,
    required Function(String?) onError,
    required Function() onSuccess,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      await db.deleteUserAccount(userId: user!.uid);
      await AuthenticationService().deleteAccount(
        email: user.email!,
        password: password,
      );
      onSuccess();
    } catch (e) {
      final error = e.toString();
      if (error.contains('The supplied auth credential is incorrect')) {
        onError('Contraseña incorrecta');
      } else if (error.contains('requires-recent-login')) {
        onError('requires-recent-login');
      } else {
        onError('Error al eliminar la cuenta');
      }
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
