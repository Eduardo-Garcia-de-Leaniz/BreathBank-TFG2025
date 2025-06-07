import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String photoString;
  final double imageWidth;
  final double imageHeight;

  const ImageWidget({
    super.key,
    required this.photoString,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Image.asset(
        photoString,
        fit: BoxFit.cover,
        width: imageWidth,
        height: imageHeight,
      ),
    );
  }
}
