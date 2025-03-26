import 'package:breath_bank/Authentication_service.dart';
import 'package:breath_bank/widgets/widgets_botones/BtnBack.dart';
import 'package:breath_bank/widgets/widgets_home_screen/Image_logo.dart';
import 'package:breath_bank/widgets/widgets_login_screen/AppBar_Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            ImagenLogo(imageWidth: 150, imageHeight: 150),
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
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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

  void signIn() async {
    try {
      await authenticationService.value.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Error desconocido';
      });
    }
  }

  // Principio SOLID: Open/Closed Principle
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
          Column(
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
          ),
          SizedBox(height: 20),
          Column(
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
          ),
          const SizedBox(height: 10),
          Text(
            errorMessage,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Arial',
              color: Colors.redAccent,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BtnBack(fontSize: 16, route: '/'),
              ElevatedButton(
                onPressed: () {
                  if (!validateInputs()) {
                    return;
                  }
                  signIn();
                  if (errorMessage.isEmpty) {
                    setState(() {
                      errorMessage = '';
                    });
                    Navigator.pushNamed(context, '/dashboard');
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
