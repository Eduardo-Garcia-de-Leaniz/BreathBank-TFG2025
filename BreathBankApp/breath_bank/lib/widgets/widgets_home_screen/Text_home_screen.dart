import 'package:flutter/material.dart';

class Text_home_screen extends StatelessWidget {
  const Text_home_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '¡Bienvenido a BreathBank!',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        fontFamily: 'Arial',
        color: const Color.fromARGB(255, 7, 71, 94),
      ),
    );
  }
}
