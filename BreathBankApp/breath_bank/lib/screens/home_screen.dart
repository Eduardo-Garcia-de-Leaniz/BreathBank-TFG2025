import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            color: Color.fromARGB(255, 7, 71, 94),
          ),

          Column(
            children: [
              TitleHomeScreen(),
              ImageLogo(imageWidth: 200, imageHeight: 200),
              SubtitleHomeScreen(),
              BtnLogin(),
              BtnRegister(),
            ],
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 188, 252, 245),
    );
  }
}

class SubtitleHomeScreen extends StatelessWidget {
  const SubtitleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '¡Bienvenido a BreathBank!',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        fontFamily: 'Arial',
        color: Color.fromARGB(255, 7, 71, 94),
      ),
    );
  }
}

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
        'assets/images/LogoPrincipal_BreathBank-sin_fondo.png',
        fit: BoxFit.cover,
        width: imageWidth,
        height: imageHeight,
      ),
    );
  }
}

class TitleHomeScreen extends StatelessWidget {
  const TitleHomeScreen({super.key});

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
                color: Color.fromARGB(255, 7, 71, 94),
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

class BtnLogin extends StatelessWidget {
  const BtnLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 60),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/login',
            arguments: {'desdeNotificacion': false},
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          backgroundColor: const Color.fromARGB(255, 7, 71, 94),
        ),
        child: const Text(
          'Iniciar Sesión',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class BtnRegister extends StatelessWidget {
  const BtnRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 30),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/register');
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
          backgroundColor: const Color.fromARGB(255, 7, 71, 94),
        ),
        child: const Text(
          'Registrarse',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
