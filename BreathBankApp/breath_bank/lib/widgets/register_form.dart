import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/widgets/app_button.dart';
import 'package:breath_bank/widgets/snackbar_widget.dart';
import 'package:breath_bank/widgets/textfield.dart';
import 'package:flutter/material.dart';
import '../controllers/register_controller.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final controller = RegisterController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    errorMessage = '';
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return RegisterStrings.emptyName;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return RegisterStrings.emptyEmail;
    } else if (!value.contains('@')) {
      return RegisterStrings.invalidEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return RegisterStrings.emptyPassword;
    } else if (value.length < 6) {
      return RegisterStrings.passwordTooShort;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return RegisterStrings.emptyConfirmPassword;
    } else if (value != passwordController.text) {
      return RegisterStrings.passwordMismatch;
    }
    return null;
  }

  Future<void> handleRegister() async {
    // ...existing code...
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          TextFieldForm(
            fontSize: 14,
            controller: nameController,
            label: RegisterStrings.name,
            hintText: RegisterStrings.hintName,
            icon: Icons.person,
            validator: _validateName,
          ),
          const SizedBox(height: 20),
          TextFieldForm(
            fontSize: 14,
            controller: emailController,
            label: RegisterStrings.email,
            hintText: RegisterStrings.hintEmail,
            icon: Icons.email,
            validator: _validateEmail,
          ),
          const SizedBox(height: 20),
          TextFieldForm(
            fontSize: 14,
            controller: passwordController,
            label: RegisterStrings.password,
            hintText: RegisterStrings.hintPassword,
            icon: Icons.lock,
            obscureText: true,
            validator: _validatePassword,
          ),
          const SizedBox(height: 20),
          TextFieldForm(
            fontSize: 14,
            controller: confirmPasswordController,
            label: RegisterStrings.confirmPassword,
            hintText: RegisterStrings.hintConfirmPassword,
            icon: Icons.lock_reset,
            obscureText: true,
            validator: _validateConfirmPassword,
          ),
          if (errorMessage.isNotEmpty) ...[
            SnackBarWidget(message: errorMessage, backgroundColor: Colors.red),
          ],
          const SizedBox(height: 80),
          Container(
            alignment: Alignment.bottomCenter,
            child: AppButton(
              text: RegisterStrings.registerButton,
              width: MediaQuery.of(context).size.width * 0.8,
              onPressed: handleRegister,
              backgroundColor: const Color.fromARGB(255, 7, 71, 94),
            ),
          ),
        ],
      ),
    );
  }
}
