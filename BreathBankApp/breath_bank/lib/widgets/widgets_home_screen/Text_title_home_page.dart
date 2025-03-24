import 'package:flutter/material.dart';

// Cambiar fuente de letra del titulo

class TextTitle_HomePage extends StatelessWidget {
  const TextTitle_HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: [
            const Text(
              'BreathBank',
              style: TextStyle(
                color: const Color.fromARGB(255, 7, 71, 94),
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
