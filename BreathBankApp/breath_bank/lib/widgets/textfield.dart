import 'package:flutter/material.dart';

class TextFieldForm extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final double fontSize;

  const TextFieldForm({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.validator,
    this.fontSize = 16, // Valor por defecto
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize + 2, // Un poco más grande para el label
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
            color: const Color.fromARGB(255, 7, 71, 94),
          ),
        ),
        Row(
          children: [
            Icon(icon, color: const Color.fromARGB(255, 7, 71, 94)),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: const Color.fromARGB(255, 7, 71, 94),
                    fontSize: fontSize,
                    fontFamily: 'Arial',
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: fontSize,
                  color: const Color.fromARGB(255, 7, 71, 94),
                ),
                validator: validator,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
