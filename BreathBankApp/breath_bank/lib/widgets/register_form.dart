import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/models/user_credentials.dart';
import 'package:breath_bank/widgets/app_button.dart';
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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.emptyName;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.emptyEmail;
    } else if (!value.contains('@')) {
      return Strings.invalidEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.emptyPassword;
    } else if (value.length < 6) {
      return Strings.passwordTooShort;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.emptyConfirmPassword;
    } else if (value != passwordController.text) {
      return Strings.passwordMismatch;
    }
    return null;
  }

  Future<void> handleRegister() async {
    setState(() => errorMessage = '');
    final credentials = UserCredentialsRegister(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
      name: nameController.text.trim(),
    );

    final validationError = await controller.validate(credentials);
    if (validationError != null) {
      setState(() => errorMessage = validationError);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: kRedAccentColor,
        ),
      );
      return;
    }

    final registerError = await controller.registerUser(
      credentials: credentials,
    );
    if (registerError != null) {
      setState(() => errorMessage = registerError);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(registerError),
          backgroundColor: kRedAccentColor,
        ),
      );
      return;
    }

    await controller.postLoginTasks(
      authenticationService.value.currentUser!.uid,
    );
    final nombreUsuario = await controller.getNombreUsuario(
      authenticationService.value.currentUser!.uid,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Has iniciado sesión correctamente. Bienvenid@ $nombreUsuario',
        ),
        backgroundColor: kGreenColor,
      ),
    );

    Navigator.pushReplacementNamed(context, "/evaluation");
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
            label: Strings.name,
            hintText: Strings.hintName,
            icon: Icons.person,
            validator: _validateName,
          ),
          const SizedBox(height: 20),
          TextFieldForm(
            fontSize: 14,
            controller: emailController,
            label: Strings.email,
            hintText: Strings.hintEmail,
            icon: Icons.email,
            validator: _validateEmail,
          ),
          const SizedBox(height: 20),
          TextFieldForm(
            fontSize: 14,
            controller: passwordController,
            label: Strings.password,
            hintText: Strings.hintPassword,
            icon: Icons.lock,
            obscureText: true,
            validator: _validatePassword,
          ),
          const SizedBox(height: 20),
          TextFieldForm(
            fontSize: 14,
            controller: confirmPasswordController,
            label: Strings.confirmPassword,
            hintText: Strings.hintConfirmPassword,
            icon: Icons.lock_reset,
            obscureText: true,
            validator: _validateConfirmPassword,
          ),

          const SizedBox(height: 30),
          Container(
            alignment: Alignment.bottomCenter,
            child: AppButton(
              text: Strings.register,
              width: MediaQuery.of(context).size.width * 0.8,
              onPressed: handleRegister,
              backgroundColor: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
