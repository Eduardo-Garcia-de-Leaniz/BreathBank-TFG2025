import 'package:flutter/material.dart';

class AppBar_Register extends StatelessWidget {
  const AppBar_Register({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Registro',
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
