import 'package:flutter/material.dart';

class Test2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar_Test2(),
      ),
      resizeToAvoidBottomInset: true,
      body: PageView(
        children: [
          // First page: Description of the test
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                color: const Color.fromARGB(255, 188, 252, 245),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Título de la Prueba',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Esta es la descripción de la prueba. Aquí puedes explicar los objetivos, '
                      'los pasos a seguir y cualquier otra información relevante para el usuario.',
                      style: TextStyle(fontSize: 16),
                    ),

                    SizedBox(height: 16),
                    Text(
                      'Instrucciones:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Paso 1: Descripción del primer paso.\n'
                      '2. Paso 2: Descripción del segundo paso.\n'
                      '3. Paso 3: Descripción del tercer paso.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 50),
                    Image.asset(
                      'assets/images/LogoPrincipal_BreathBank-sin_fondo.png',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 8,
                top: MediaQuery.of(context).size.height / 2 - 20,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: const Color.fromARGB(255, 7, 71, 94),
                ),
              ),
            ],
          ),
          // Second page: The test itself
          Container(
            color: Colors.grey[200],
            child: Center(
              child: Text(
                'Aquí va el contenido de la prueba',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppBar_Test2 extends StatelessWidget {
  const AppBar_Test2({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Test2',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: 'Arial',
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 7, 71, 94),
    );
  }
}
