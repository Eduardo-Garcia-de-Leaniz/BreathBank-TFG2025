import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/models/user_credentials.dart';
import 'package:breath_bank/widgets/textfield.dart';
import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import 'package:breath_bank/widgets/app_button.dart';

class LoginForm extends StatefulWidget {
  final bool desdeNotificacion;
  final LoginController? injectedController;
  const LoginForm({
    super.key,
    required this.desdeNotificacion,
    this.injectedController,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final LoginController controller;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessageLogin = '';

  @override
  void initState() {
    super.initState();
    controller = widget.injectedController ?? LoginController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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

  Future<void> _handleLogin() async {
    setState(() => errorMessageLogin = '');
    final credentials = UserCredentials(
      email: emailController.text,
      password: passwordController.text,
    );

    final validationError = controller.validate(credentials);
    if (validationError != null) {
      setState(() => errorMessageLogin = validationError);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessageLogin),
          backgroundColor: kRedAccentColor,
        ),
      );
      return;
    }

    final loginError = await controller.signIn(credentials);
    if (loginError != null) {
      setState(() => errorMessageLogin = Strings.errorLogin);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.errorLogin),
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

    if (widget.desdeNotificacion) {
      Navigator.pushReplacementNamed(
        context,
        "/dashboard/appsettings/notifications",
      );
    } else {
      Navigator.pushReplacementNamed(context, "/dashboard");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          TextFieldForm(
            controller: emailController,
            label: Strings.email,
            hintText: Strings.hintEmail,
            icon: Icons.email,
            validator: _validateEmail,
          ),
          const SizedBox(height: 20),
          TextFieldForm(
            controller: passwordController,
            label: Strings.password,
            hintText: Strings.hintPassword,
            icon: Icons.lock,
            obscureText: true,
            validator: _validatePassword,
          ),
          const SizedBox(height: 30),

          AppButton(
            text: Strings.login,
            width: MediaQuery.of(context).size.width * 0.8,
            onPressed: _handleLogin,
            backgroundColor: const Color.fromARGB(255, 7, 71, 94),
          ),
        ],
      ),
    );
  }
}
