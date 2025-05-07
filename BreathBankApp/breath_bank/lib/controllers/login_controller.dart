import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_credentials.dart';

class LoginController {
  final DatabaseService db = DatabaseService();

  Future<String?> signIn(UserCredentials credentials) async {
    try {
      await authenticationService.value.signIn(
        email: credentials.email,
        password: credentials.password,
      );
      return null; // No error
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Error desconocido';
    }
  }

  String? validate(UserCredentials credentials) {
    if (credentials.email.isEmpty) {
      return 'Introduce un correo electrónico';
    } else if (!credentials.email.contains('@')) {
      return 'Correo electrónico inválido';
    } else if (credentials.password.isEmpty) {
      return 'Introduce una contraseña';
    } else if (credentials.password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
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
