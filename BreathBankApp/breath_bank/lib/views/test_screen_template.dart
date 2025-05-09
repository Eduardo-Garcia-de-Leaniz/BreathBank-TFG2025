import 'package:breath_bank/views/base_screen.dart';
import 'package:flutter/material.dart';

class TestScreenTemplate extends StatelessWidget {
  final Widget description;
  final Widget interactiveContent;
  final String title;
  const TestScreenTemplate({
    super.key,
    required this.title,
    required this.description,
    required this.interactiveContent,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      canGoBack: false,
      title: title, // Título del AppBar
      child: SingleChildScrollView(
        // Hace que el contenido sea desplazable
        child: SizedBox(
          height:
              MediaQuery.of(
                context,
              ).size.height, // Asegura que ocupe toda la pantalla
          child: PageView(
            children: [
              // Primera parte de la prueba: descripción o instrucciones
              Stack(
                children: [
                  Container(child: description),
                  const ArrowNextSymbol(),
                ],
              ),
              // Segunda parte de la prueba: contenido interactivo
              Stack(
                children: [
                  Container(child: interactiveContent),
                  const ArrowPreviousSymbol(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArrowPreviousSymbol extends StatelessWidget {
  const ArrowPreviousSymbol({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 5,
      top: MediaQuery.of(context).size.height * 3 / 8,
      child: const Icon(
        Icons.arrow_back_ios,
        color: Color.fromARGB(255, 7, 71, 94),
      ),
    );
  }
}

class ArrowNextSymbol extends StatelessWidget {
  const ArrowNextSymbol({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5,
      top: MediaQuery.of(context).size.height * 3 / 8,
      child: const Icon(
        Icons.arrow_forward_ios,
        color: Color.fromARGB(255, 7, 71, 94),
      ),
    );
  }
}
