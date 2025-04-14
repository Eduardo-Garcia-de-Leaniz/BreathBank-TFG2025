import 'package:breath_bank/Authentication_service.dart';
import 'package:breath_bank/widgets/widgets_botones/BtnBack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:breath_bank/Database_service.dart';
import 'package:flutter/material.dart';

// Falta añadir recuperar/restablecer contraseña
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar_Login(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageLogo(imageWidth: 150, imageHeight: 150),
            ClickableTextLoginRegister(),
            LoginForm(),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  Database_service db = Database_service();
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

  // Principio SOLID: Open/Closed Principle
  // Se crea un método para añadir futuras validaciones solo en este punto, y no en todo el código
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
          SizedBox(height: 20),
          TextFieldPassword(passwordController: passwordController),
          const SizedBox(height: 10),
          ErrorMessageWidget(errorMessage: errorMessage),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BtnBack(fontSize: 16, route: '/'),
              ElevatedButton(
                onPressed: () async {
                  if (!validateInputs()) {
                    return;
                  }
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
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/dashboard");
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
  const ErrorMessageWidget({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Arial',
        color: Colors.redAccent,
      ),
    );
  }
}

class TextFieldPassword extends StatelessWidget {
  const TextFieldPassword({super.key, required this.passwordController});

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
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
            Icon(Icons.lock, color: Color.fromARGB(255, 7, 71, 94)),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Ingrese su contraseña',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 7, 71, 94),
                    fontSize: 16,
                    fontFamily: 'Arial',
                  ),
                ),
                style: TextStyle(
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
  const TextFieldEmail({super.key, required this.emailController});

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
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
            Icon(Icons.email, color: Color.fromARGB(255, 7, 71, 94)),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Ingrese su correo electrónico',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 7, 71, 94),
                    fontSize: 16,
                    fontFamily: 'Arial',
                  ),
                ),
                style: TextStyle(
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
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'Iniciar Sesión',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arial',
              color: Color.fromARGB(255, 150, 150, 150),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/register');
          },
          child: Container(
            alignment: Alignment.centerRight,
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
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: 'Arial',
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
    );
  }
}
