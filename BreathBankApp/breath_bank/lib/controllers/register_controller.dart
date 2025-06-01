import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/database_service.dart';
import 'package:breath_bank/models/user_credentials.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController {
  final DatabaseService db;

  RegisterController({DatabaseService? db}) : db = db ?? DatabaseService();

  Future<String?> registerUser({
    required UserCredentialsRegister credentials,
  }) async {
    try {
      await authenticationService.value.createAccount(
        email: credentials.email,
        password: credentials.password,
      );
      await db.addNewUser(
        userId: authenticationService.value.currentUser!.uid,
        nombre: credentials.name,
        fechaCreacion: DateTime.now(),
      );
      return null; // No error
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Error desconocido';
    }
  }

  Future<String?> validate(UserCredentialsRegister credentials) async {
    if (credentials.name.isEmpty) return 'Introduce un nombre de usuario';
    if (credentials.email.isEmpty) return 'Introduce un correo electrónico';
    if (!credentials.email.contains('@')) return 'Correo electrónico inválido';
    if (credentials.password.isEmpty) return 'Introduce una contraseña';
    if (credentials.password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    if (credentials.password != credentials.confirmPassword) {
      return 'Las contraseñas no coinciden';
    }
    return null; // No error
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
