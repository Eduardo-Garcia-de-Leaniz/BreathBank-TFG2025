import 'package:flutter/material.dart';

class SnackBarWidget extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Duration duration;

  const SnackBarWidget({
    super.key,
    required this.message,
    required this.backgroundColor,
    this.duration = const Duration(seconds: 3),
  });

  @override
  Widget build(BuildContext context) {
    // Muestra el SnackBar con los parámetros personalizados
    Future.delayed(Duration.zero, () {
      if (!context.mounted) return; // Verifica si el contexto está montado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          duration: duration,
        ),
      );
    });

    return const SizedBox.shrink(); // Este widget no renderiza nada visualmente
  }
}
