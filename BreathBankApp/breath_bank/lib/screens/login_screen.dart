import 'package:breath_bank/Authentication_service.dart';
import 'package:breath_bank/widgets/widgets_botones/BtnBack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:breath_bank/Database_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final bool desdeNotificacion;

  const LoginScreen({super.key, required this.desdeNotificacion});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar_Login(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ImageLogo(imageWidth: 150, imageHeight: 150),
            const ClickableTextLoginRegister(),
            LoginForm(desdeNotificacion: widget.desdeNotificacion),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
    );
  }
}

class LoginForm extends StatefulWidget {
  final bool desdeNotificacion;

  const LoginForm({super.key, this.desdeNotificacion = false});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  DatabaseService db = DatabaseService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<bool> signIn() async {
    errorMessage = '';
    try {
      await authenticationService.value.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Error desconocido';
      });
      return false;
    }
    return true;
  }

  bool validateInputs() {
    if (emailController.text.isEmpty) {
      setState(() {
        errorMessage = 'Introduce un correo electrónico';
      });
      return false;
    } else if (passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Introduce una contraseña';
      });
      return false;
    } else if (!emailController.text.contains('@')) {
      setState(() {
        errorMessage = 'Correo electrónico inválido';
      });
      return false;
    } else if (passwordController.text.length < 6) {
      setState(() {
        errorMessage = 'La contraseña debe tener al menos 6 caracteres';
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          TextFieldEmail(emailController: emailController),
          const SizedBox(height: 20),
          TextFieldPassword(passwordController: passwordController),
          const SizedBox(height: 10),
          ErrorMessageWidget(errorMessage: errorMessage),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BtnBack(fontSize: 16, route: '/'),
              ElevatedButton(
                onPressed: () async {
                  if (!validateInputs()) return;
                  await signIn();
                  if (errorMessage.isEmpty) {
                    setState(() {
                      errorMessage = '';
                    });
                    try {
                      await db.updateFechaUltimoAcceso(
                        userId: authenticationService.value.currentUser!.uid,
                        fechaUltimoAcceso: DateTime.now(),
                      );
                    } catch (e) {
                      setState(() {
                        errorMessage =
                            'Error al actualizar datos de usuario: $e';
                      });
                    }
                    final String? nombreUsuario = await db.getNombreUsuario(
                      userId: authenticationService.value.currentUser!.uid,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Has iniciado sesión correctamente. Bienvenid@ $nombreUsuario',
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );

                    if (widget.desdeNotificacion) {
                      Navigator.pushReplacementNamed(
                        context,
                        "/dashboard/appsettings/notifications",
                      );
                    } else {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, "/dashboard");
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  backgroundColor: const Color.fromARGB(255, 7, 71, 94),
                ),
                child: const Text(
                  'Siguiente',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ErrorMessageWidget extends StatelessWidget {
  final String errorMessage;

  const ErrorMessageWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'Arial',
        color: Colors.redAccent,
      ),
    );
  }
}

class TextFieldPassword extends StatelessWidget {
  final TextEditingController passwordController;

  const TextFieldPassword({super.key, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contraseña',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
            color: Color.fromARGB(255, 7, 71, 94),
          ),
        ),
        Row(
          children: [
            const Icon(Icons.lock, color: Color.fromARGB(255, 7, 71, 94)),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Ingrese su contraseña',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 7, 71, 94),
                    fontSize: 16,
                    fontFamily: 'Arial',
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  color: Color.fromARGB(255, 7, 71, 94),
                ),
                obscureText: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TextFieldEmail extends StatelessWidget {
  final TextEditingController emailController;

  const TextFieldEmail({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Correo Electrónico',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
            color: Color.fromARGB(255, 7, 71, 94),
          ),
        ),
        Row(
          children: [
            const Icon(Icons.email, color: Color.fromARGB(255, 7, 71, 94)),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Ingrese su correo electrónico',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 7, 71, 94),
                    fontSize: 16,
                    fontFamily: 'Arial',
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  color: Color.fromARGB(255, 7, 71, 94),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ClickableTextLoginRegister extends StatelessWidget {
  const ClickableTextLoginRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          'Iniciar Sesión',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
            color: Color.fromARGB(255, 150, 150, 150),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/register');
          },
          child: const Text(
            'Registrarse',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arial',
              color: Color.fromARGB(255, 7, 71, 94),
            ),
          ),
        ),
      ],
    );
  }
}

class ImageLogo extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;

  const ImageLogo({
    super.key,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Image.asset(
        'assets/images/LogoPrincipal_BreathBank-sin_fondo.png',
        fit: BoxFit.cover,
        width: imageWidth,
        height: imageHeight,
      ),
    );
  }
}

class AppBar_Login extends StatelessWidget {
  const AppBar_Login({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Inicio de Sesión',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: 'Arial',
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
    );
  }
}
