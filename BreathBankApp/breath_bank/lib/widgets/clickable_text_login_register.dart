import 'package:flutter/material.dart';

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
