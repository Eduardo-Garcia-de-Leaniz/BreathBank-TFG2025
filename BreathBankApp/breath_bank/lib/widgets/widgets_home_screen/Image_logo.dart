import 'package:flutter/material.dart';

class ImagenLogo extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;

  const ImagenLogo({
    super.key,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Image.asset(
        'assets/images/LogoPrincipal_BreathBank-sin_fondo.png',
        fit: BoxFit.cover,
        width: imageWidth, // Usa el ancho pasado como parámetro
        height: imageHeight, // Usa la altura pasada como parámetro
      ),
    );
  }
}
