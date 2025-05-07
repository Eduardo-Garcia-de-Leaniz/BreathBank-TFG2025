import 'package:flutter/material.dart';

class AppBarLogin extends StatelessWidget {
  const AppBarLogin({super.key});

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
