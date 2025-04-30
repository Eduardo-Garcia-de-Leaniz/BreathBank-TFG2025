import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class GuidedInvestmentScreen extends StatefulWidget {
  const GuidedInvestmentScreen({super.key});

  @override
  State<GuidedInvestmentScreen> createState() => _GuidedInvestmentScreenState();
}

class _GuidedInvestmentScreenState extends State<GuidedInvestmentScreen> {
  late Timer _timer;
  bool isRunning = false;
  bool isPaused = false;
  bool isInhaling = true;

  int totalBreaths = 10; // Número total de respiraciones deseadas
  int breathsDone = 0;

  int totalTime = 60; // Duración total de la prueba en segundos
  int elapsedTime = 0;

  final player = AudioPlayer();

  @override
  void dispose() {
    _timer.cancel();
    player.dispose();
    super.dispose();
  }

  void startTest() {
    setState(() {
      isRunning = true;
      isPaused = false;
      breathsDone = 0;
      elapsedTime = 0;
      isInhaling = true;
    });
    _startTimer();
    _playBeep(1); // Sonido para empezar la inspiración (beep1)
  }

  void pauseTest() {
    setState(() {
      isPaused = true;
    });
    _timer.cancel();
  }

  void resumeTest() {
    setState(() {
      isPaused = false;
    });
    _startTimer();
  }

  void resetTest() {
    setState(() {
      isRunning = false;
      isPaused = false;
      breathsDone = 0;
      elapsedTime = 0;
      isInhaling = true;
    });
    _timer.cancel();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!isPaused) {
        setState(() {
          elapsedTime += 3;
          if (elapsedTime >= totalTime) {
            _timer.cancel();
            isRunning = false;
          } else {
            if (isInhaling) {
              _playBeep(1); // 1 pitido para comenzar la inspiración (beep1)
            } else {
              _playBeep(2); // 2 pitidos para comenzar la exhalación (beep2)
              breathsDone++;
            }
            isInhaling = !isInhaling;
          }
        });
      }
    });
  }

  Future<void> _playBeep(int count) async {
    String beepSound = count == 1 ? 'sounds/beep1.wav' : 'sounds/beep2.wav';

    for (int i = 0; i < count; i++) {
      await player.play(AssetSource(beepSound));
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  @override
  Widget build(BuildContext context) {
    //final int listonInversion = ModalRoute.of(context)!.settings.arguments as int;

    int remainingTime = totalTime - elapsedTime;
    int breathsRemaining = totalBreaths - breathsDone;

    return Scaffold(
      appBar: AppBar(title: const Text('Inversión Guiada')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isInhaling ? 'Inspirar' : 'Espirar',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Respiraciones completadas: $breathsDone'),
            Text('Respiraciones restantes: $breathsRemaining'),
            const SizedBox(height: 20),
            Text('Tiempo transcurrido: ${elapsedTime}s'),
            Text('Tiempo restante: ${remainingTime > 0 ? remainingTime : 0}s'),
            const SizedBox(height: 40),
            if (!isRunning)
              ElevatedButton(
                onPressed: startTest,
                child: const Text('Comenzar'),
              )
            else if (isPaused)
              ElevatedButton(
                onPressed: resumeTest,
                child: const Text('Reanudar'),
              )
            else
              ElevatedButton(onPressed: pauseTest, child: const Text('Pausar')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: resetTest,
              child: const Text('Restablecer'),
            ),
          ],
        ),
      ),
    );
  }
}
