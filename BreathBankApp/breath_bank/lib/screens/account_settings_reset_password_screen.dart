import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountSettingsResetPasswordScreen extends StatefulWidget {
  const AccountSettingsResetPasswordScreen({super.key});

  @override
  State<AccountSettingsResetPasswordScreen> createState() =>
      _AccountSettingsResetPasswordScreenState();
}

class _AccountSettingsResetPasswordScreenState
    extends State<AccountSettingsResetPasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  DatabaseService db = DatabaseService();
  AuthenticationService authenticationService = AuthenticationService();
  String currentEmail = FirebaseAuth.instance.currentUser!.email!;

  bool _obscureCurrent = true;
  bool _obscureNew = true;

  bool areFieldsNotEmpty() {
    return emailController.text.isNotEmpty &&
        currentPasswordController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty;
  }

  bool isNewPasswordDifferent() {
    return currentPasswordController.text != newPasswordController.text;
  }

  bool isEmailMatching() {
    return emailController.text == currentEmail;
  }

  void updatePassword() async {
    if (!areFieldsNotEmpty()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, completa todos los campos"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!isEmailMatching()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("El email no coincide con el actual"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!isNewPasswordDifferent()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La nueva contraseña no puede ser igual a la actual"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await authenticationService.resetPasswordFromCurrentPassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        email: emailController.text,
      );

      if (!mounted) return; // ✅ importante

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Contraseña actualizada con éxito"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al actualizar la contraseña"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required bool isPassword,
    required Icon prefixIcon,
    VoidCallback? onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon,
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: onToggle,
                )
                : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarResetPassword(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Por seguridad, ingresa tu contraseña actual y elige una nueva.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 7, 71, 94),
                ),
              ),
              const SizedBox(height: 20),
              buildTextField(
                label: "Introduce tu email",
                controller: emailController,
                obscureText: false,
                isPassword: false,
                prefixIcon: const Icon(Icons.email),
              ),
              const SizedBox(height: 16),
              buildTextField(
                label: "Contraseña Actual",
                controller: currentPasswordController,
                obscureText: _obscureCurrent,
                isPassword: true,
                prefixIcon: const Icon(Icons.lock_outline),
                onToggle: () {
                  setState(() {
                    _obscureCurrent = !_obscureCurrent;
                  });
                },
              ),
              const SizedBox(height: 16),
              buildTextField(
                label: "Nueva Contraseña",
                controller: newPasswordController,
                obscureText: _obscureNew,
                isPassword: true,
                prefixIcon: const Icon(Icons.lock_reset),
                onToggle: () {
                  setState(() {
                    _obscureNew = !_obscureNew;
                  });
                },
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 7, 71, 94),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Restablecer Contraseña",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
    );
  }
}

class AppBarResetPassword extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarResetPassword({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      title: const Text(
        'Restablecer Contraseña',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
