import 'package:flutter/material.dart';

class EvaluationScreen extends StatelessWidget {
  const EvaluationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar_Evaluation(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Evaluación',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'A continuación se presentan 3 pruebas muy sencillas para valorar tus capacidades pulmonares.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  Stack(
                    children: [
                      LinearProgressIndicator(
                        value:
                            0.0, // Cambiar este valor dinámicamente según el progreso
                        backgroundColor: Colors.grey[300],
                        color: Colors.blue,
                        minHeight: 30, // Hacer la barra más ancha
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            '0%', // Cambiar este texto dinámicamente según el progreso
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check,
                              color: Colors.transparent,
                            ), // Cambiar a Icons.check cuando se complete
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                // Navegar a la página de la primera prueba
                                Navigator.pushNamed(
                                  context,
                                  '/evaluation/test1',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 45.0,
                                ),
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  7,
                                  71,
                                  94,
                                ), // Azul oscuro
                                foregroundColor: Colors.white, // Letras blancas
                              ),
                              child: const Text(
                                'Prueba 1',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check,
                              color: Colors.transparent,
                            ), // Cambiar a Icons.check cuando se complete
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                // Navegar a la página de la segunda prueba
                                Navigator.pushNamed(
                                  context,
                                  '/evaluation/test2',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 45.0,
                                ),
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  7,
                                  71,
                                  94,
                                ), // Azul oscuro
                                foregroundColor: Colors.white, // Letras blancas
                              ),
                              child: const Text(
                                'Prueba 2',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check,
                              color: Colors.transparent,
                            ), // Cambiar a Icons.check cuando se complete
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                // Navegar a la página de la tercera prueba
                                Navigator.pushNamed(
                                  context,
                                  '/evaluation/test3',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 45.0,
                                ),
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  7,
                                  71,
                                  94,
                                ), // Azul oscuro
                                foregroundColor: Colors.white, // Letras blancas
                              ),
                              child: const Text(
                                'Prueba 3',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed:
                      false
                          ? null
                          : () {
                            // Acción al completar las 3 pruebas
                            Navigator.of(context).pushNamed('/resultado');
                          },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    backgroundColor: const Color.fromARGB(
                      255,
                      7,
                      71,
                      94,
                    ), // Azul oscuro
                    foregroundColor: Colors.white, // Letras blancas
                  ),
                  child: const Text('Continuar'),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
    );
  }
}

class AppBar_Evaluation extends StatelessWidget {
  const AppBar_Evaluation({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Evaluación',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: 'Arial',
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        },
      ),
    );
  }
}
