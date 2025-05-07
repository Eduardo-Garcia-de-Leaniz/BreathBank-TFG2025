import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/widgets/snackbar_widget.dart';
import 'package:breath_bank/widgets/textfield.dart';

import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import '../models/user_credentials.dart';
import '../widgets/widgets_botones/btnBack.dart';
import 'package:breath_bank/widgets/app_button.dart';

class LoginForm extends StatefulWidget {
  final bool desdeNotificacion;
  const LoginForm({super.key, required this.desdeNotificacion});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final controller = LoginController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final credentials = UserCredentials(
      email: emailController.text,
      password: passwordController.text,
    );

    final validationError = controller.validate(credentials);
    if (validationError != null) {
      setState(() => errorMessage = validationError);
      return;
    }

    final loginError = await controller.signIn(credentials);
    if (loginError != null) {
      setState(() => errorMessage = loginError);
      return;
    }

    await controller.postLoginTasks(
      authenticationService.value.currentUser!.uid,
    );
    final nombreUsuario = await controller.getNombreUsuario(
      authenticationService.value.currentUser!.uid,
    );

    // Verifica si el widget aún está montado antes de usar BuildContext
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Has iniciado sesión correctamente. Bienvenid@ $nombreUsuario',
        ),
        backgroundColor: Colors.green,
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
            label: 'Correo Electrónico',
            hintText: 'Ingrese su correo electrónico',
            icon: Icons.email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Introduce un correo electrónico';
              } else if (!value.contains('@')) {
                return 'Correo electrónico inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFieldForm(
            controller: passwordController,
            label: 'Contraseña',
            hintText: 'Ingrese su contraseña',
            icon: Icons.lock,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Introduce una contraseña';
              } else if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          SnackBarWidget(message: errorMessage, backgroundColor: Colors.red),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BtnBack(fontSize: 16, route: '/'),
              AppButton(
                text: 'Siguiente',
                onPressed: _handleLogin,
                backgroundColor: const Color.fromARGB(255, 7, 71, 94),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
