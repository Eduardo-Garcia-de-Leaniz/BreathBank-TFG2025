import 'package:breath_bank/Database_service.dart';
import 'package:flutter/material.dart';

class BtnLogin extends StatelessWidget {
  const BtnLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 60),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/login');
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          backgroundColor: const Color.fromARGB(255, 7, 71, 94),
        ),
        child: const Text(
          'Iniciar Sesión',
          style: TextStyle(
            fontFamily: 'Roboto', // Cambia 'Roboto' por la fuente deseada
            fontSize: 20, // Tamaño de la fuente
            fontWeight: FontWeight.bold, // Peso de la fuente
            color: Colors.white, // Letras blancas
          ),
        ),
      ),
    );
  }
}
