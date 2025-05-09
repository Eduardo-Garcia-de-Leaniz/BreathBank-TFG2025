import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController {
  final DatabaseService db = DatabaseService();

  Future<String?> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
  }) async {
    if (name.isEmpty) return 'Introduce tu nombre de usuario';
    if (email.isEmpty) return 'Introduce un correo electrónico';
    if (!email.contains('@')) return 'Correo electrónico inválido';
    if (password.isEmpty) return 'Introduce una contraseña';
    if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    if (password != confirmPassword) return 'Las contraseñas no coinciden';

    try {
      await authenticationService.value.createAccount(
        email: email,
        password: password,
      );
      await db.addNewUser(
        userId: authenticationService.value.currentUser!.uid,
        nombre: name,
        fechaCreacion: DateTime.now(),
      );
      return null; // No error
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'El correo electrónico ya está registrado';
      }
      return e.message ?? 'Error desconocido';
    }
  }

  Future<void> postLoginTasks(String userId) async {
    await db.updateFechaUltimoAcceso(
      userId: userId,
      fechaUltimoAcceso: DateTime.now(),
    );
  }

  Future<String?> getNombreUsuario(String userId) async {
    return await db.getNombreUsuario(userId: userId);
  }
}
