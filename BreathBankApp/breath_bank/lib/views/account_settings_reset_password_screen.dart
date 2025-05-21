import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/controllers/account_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/views/base_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountSettingsResetPasswordScreen extends StatefulWidget {
  const AccountSettingsResetPasswordScreen({super.key});

  @override
  State<AccountSettingsResetPasswordScreen> createState() =>
      _AccountSettingsResetPasswordScreenState();
}

class _AccountSettingsResetPasswordScreenState
    extends State<AccountSettingsResetPasswordScreen> {
  final AccountSettingsController controller = AccountSettingsController();

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  late String currentEmail;

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    currentEmail = FirebaseAuth.instance.currentUser!.email!;
    emailController.text = currentEmail;
  }

  bool areFieldsNotEmpty() {
    return emailController.text.isNotEmpty &&
        currentPasswordController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  bool isNewPasswordDifferent() {
    return currentPasswordController.text != newPasswordController.text;
  }

  bool isEmailMatching() {
    return emailController.text == currentEmail;
  }

  bool isPasswordConfirmed() {
    return newPasswordController.text == confirmPasswordController.text;
  }

  void updatePassword() async {
    if (!areFieldsNotEmpty()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, completa todos los campos"),
          backgroundColor: kRedAccentColor,
        ),
      );
      return;
    }

    if (!isEmailMatching()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("El email no coincide con el actual"),
          backgroundColor: kRedAccentColor,
        ),
      );
      return;
    }

    if (!isNewPasswordDifferent()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La nueva contraseña no puede ser igual a la actual"),
          backgroundColor: kRedAccentColor,
        ),
      );
      return;
    }

    if (!isPasswordConfirmed()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Las contraseñas nuevas no coinciden"),
          backgroundColor: kRedAccentColor,
        ),
      );
      return;
    }

    try {
      await controller.resetPasswordFromCurrentPassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        email: emailController.text,
      );

      if (!mounted) return;

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
    return BaseScreen(
      title: 'Restablecer Contraseña',
      canGoBack: true,
      isScrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Por seguridad, ingresa tu contraseña actual y elige una nueva.",
            style: TextStyle(fontSize: 16, color: kPrimaryColor),
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
            prefixIcon: const Icon(Icons.lock),
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
          const SizedBox(height: 16),
          buildTextField(
            label: "Confirmar Nueva Contraseña",
            controller: confirmPasswordController,
            obscureText: _obscureConfirm,
            isPassword: true,
            prefixIcon: const Icon(Icons.lock_reset),
            onToggle: () {
              setState(() {
                _obscureConfirm = !_obscureConfirm;
              });
            },
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: updatePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Restablecer Contraseña",
                style: TextStyle(fontSize: 16, color: kWhiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
