import 'package:flutter/material.dart';

class ImageLogo extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;

  const ImageLogo({
    super.key,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Image.asset(
        'assets/images/LogoPrincipalBreathBank.png',
        fit: BoxFit.cover,
        width: imageWidth,
        height: imageHeight,
      ),
    );
  }
}
