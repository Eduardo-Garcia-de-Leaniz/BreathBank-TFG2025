import 'package:breath_bank/Authentication_service.dart';
import 'package:breath_bank/widgets/widgets_botones/BtnBack.dart';
import 'package:breath_bank/widgets/widgets_home_screen/Image_logo.dart';
import 'package:breath_bank/widgets/widgets_login_screen/AppBar_Register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar_Register(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImagenLogo(imageWidth: 100, imageHeight: 100),
            ClickableTextLoginRegister(),
            RegisterForm(),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String errorMessage = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<bool> register() async {
    try {
      await authenticationService.value.createAccount(
        email: emailController.text,
        password: passwordController.text,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          errorMessage = 'El correo electrónico ya está registrado';
        });
        return false;
      } else {
        setState(() {
          errorMessage = e.message ?? 'Error desconocido';
        });
        return false;
      }
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
    } else if (confirmPasswordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Repite la contraseña';
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
    } else if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Las contraseñas no coinciden';
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
                        hintText: 'Introduce tu correo electrónico',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 7, 71, 94),
                          fontSize: 16,
                          fontFamily: 'Arial',
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Arial',
                        color: Colors.black,
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
                        hintText: 'Introduce tu contraseña',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 7, 71, 94),
                          fontSize: 16,
                          fontFamily: 'Arial',
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Arial',
                        color: Color.fromARGB(255, 7, 71, 94),
                      ),
                      obscureText: true,
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
                'Repetir Contraseña',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                  color: Color.fromARGB(255, 7, 71, 94),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    color: Color.fromARGB(255, 7, 71, 94),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Repite tu contraseña',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 7, 71, 94),
                          fontSize: 16,
                          fontFamily: 'Arial',
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Arial',
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
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BtnBack(fontSize: 16, route: '/'),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    errorMessage = '';
                  });
                  if (!validateInputs()) {
                    return;
                  }
                  await register();
                  if (errorMessage.isEmpty) {
                    setState(() {
                      errorMessage = '';
                    });
                    Navigator.pushNamed(context, '/evaluation');
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
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
                color: Color.fromARGB(255, 7, 71, 94),
              ),
            ),
          ),
        ),

        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'Registrarse',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arial',
              color: Color.fromARGB(255, 150, 150, 150),
            ),
          ),
        ),
      ],
    );
  }
}
