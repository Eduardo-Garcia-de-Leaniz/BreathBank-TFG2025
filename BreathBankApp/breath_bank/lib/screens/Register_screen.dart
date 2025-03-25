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

class BtnNext extends StatelessWidget {
  final String route;

  const BtnNext({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          //Navigator.pushNamed(context, route);
          //register();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          backgroundColor: const Color.fromARGB(255, 7, 71, 94),
        ),
        child: const Text(
          'Siguiente',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
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

  void register() async {
    try {
      await authenticationService.value.createAccount(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Error desconocido';
      });
    }
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
                onPressed: () {
                  register();
                  if (errorMessage.isEmpty) {
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
