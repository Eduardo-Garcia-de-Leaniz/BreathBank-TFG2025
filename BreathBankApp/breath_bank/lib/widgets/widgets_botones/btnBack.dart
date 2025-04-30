import 'package:flutter/material.dart';

class BtnBack extends StatelessWidget {
  final double fontSize;
  final String route;

  const BtnBack({super.key, required this.fontSize, required this.route});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      ),
      child: Text(
        'Atrás',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
