import 'package:flutter/material.dart';

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
