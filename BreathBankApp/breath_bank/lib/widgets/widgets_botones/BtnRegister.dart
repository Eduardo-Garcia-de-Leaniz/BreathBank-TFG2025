import 'package:flutter/material.dart';

class BtnRegister extends StatelessWidget {
  const BtnRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 30),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/register');
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
          backgroundColor: const Color.fromARGB(255, 7, 71, 94),
        ),
        child: const Text(
          'Registrarse',
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
