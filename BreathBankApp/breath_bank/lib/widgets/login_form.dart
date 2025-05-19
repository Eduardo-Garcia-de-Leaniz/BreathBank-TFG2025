import 'package:breath_bank/authentication_service.dart';
import 'package:breath_bank/models/user_credentials.dart';
import 'package:breath_bank/widgets/textfield.dart';
import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
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
  String errorMessageLogin = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Introduce un correo electrónico';
    } else if (!value.contains('@')) {
      return 'Correo electrónico inválido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Introduce una contraseña';
    } else if (value.length < 6) {
      return 'La contraseña es demasiado corta';
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
        SnackBar(content: Text(errorMessageLogin), backgroundColor: Colors.red),
      );
      return;
    }

    final loginError = await controller.signIn(credentials);
    if (loginError != null) {
      setState(() => errorMessageLogin = 'Las credenciales son incorrectas');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Las credenciales son incorrectas'),
          backgroundColor: Colors.red,
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
            label: 'Correo electrónico',
            hintText: 'Introduce tu correo electrónico',
            icon: Icons.email,
            validator: _validateEmail,
          ),
          const SizedBox(height: 20),
          TextFieldForm(
            controller: passwordController,
            label: 'Contraseña',
            hintText: 'Introduce tu contraseña',
            icon: Icons.lock,
            obscureText: true,
            validator: _validatePassword,
          ),
          const SizedBox(height: 10),

          const SizedBox(height: 80),
          AppButton(
            text: 'Iniciar sesión',
            width: MediaQuery.of(context).size.width * 0.8,
            onPressed: _handleLogin,
            backgroundColor: const Color.fromARGB(255, 7, 71, 94),
          ),
        ],
      ),
    );
  }
}
