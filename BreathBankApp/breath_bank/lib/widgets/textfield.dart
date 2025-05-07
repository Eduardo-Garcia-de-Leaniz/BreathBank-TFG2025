import 'package:flutter/material.dart';

class TextFieldForm extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const TextFieldForm({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
            color: Color.fromARGB(255, 7, 71, 94),
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
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 7, 71, 94),
                    fontSize: 16,
                    fontFamily: 'Arial',
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  color: Color.fromARGB(255, 7, 71, 94),
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
