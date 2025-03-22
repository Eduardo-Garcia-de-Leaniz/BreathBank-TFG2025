import 'package:flutter/material.dart';

// Falta quitar bien el fondo a la imagen

class ImagenLogo extends StatelessWidget {
  const ImagenLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Image.asset(
        'assets/images/LogoPrincipal_BreathBank-sin_fondo.png',
        fit: BoxFit.cover,
        width: 200, // Adjust the width
        height: 200, // Adjust the height
      ),
    );
  }
}
