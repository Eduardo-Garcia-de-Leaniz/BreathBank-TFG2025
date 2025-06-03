import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class InvestmentTestModel {
  final AudioPlayer player;
  InvestmentTestModel({AudioPlayer? player}) : player = player ?? AudioPlayer();

  int secondsElapsed = 0;
  int phaseCounter = 0;
  int breathCount = 0;
  bool isRunning = false;
  bool hasStarted = false;
  bool isTimeUp = false;
  int timeLimit = 0;
  int targetBreaths = 0;
  double duracionFase = 0;
  int listonInversion = 0;
  String tipoInversion = '';

  Timer? _timer;

  void initialize({
    required int duracionMinutos,
    required int listonInversion,
    required String tipoInversion,
  }) {
    this.tipoInversion = tipoInversion;
    timeLimit = duracionMinutos * 60;
    targetBreaths = calculateNumBreaths(listonInversion, duracionMinutos);
    duracionFase = 0.25 * listonInversion + 2.5;
    this.listonInversion = listonInversion;
  }

  void startTimer(Function onTick, Function onComplete) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsElapsed >= timeLimit) {
        stopTimer();
        onComplete();
      } else {
        secondsElapsed++;
        if (tipoInversion == 'Guiada' &&
            secondsElapsed % duracionFase.floor() == 0) {
          _playBeep(phaseCounter % 2 == 0 ? 1 : 2); // Pitido según la fase
          phaseCounter++;
          if (phaseCounter % 2 == 0) {
            breathCount++;
          }
        }
        onTick();
      }
    });
    isRunning = true;
    hasStarted = true;
    isTimeUp = false;
  }

  /// Detiene el temporizador
  void stopTimer() {
    _timer?.cancel();
    if (secondsElapsed >= timeLimit) {
      isTimeUp = true;
    }
    isRunning = false;
  }

  /// Reinicia el temporizador
  void resetTimer() {
    _timer?.cancel();
    secondsElapsed = 0;
    breathCount = 0;
    phaseCounter = 0;
    isRunning = false;
    hasStarted = false;
    isTimeUp = false;
  }

  /// Marca una fase (solo para inversiones manuales)
  void markPhase() {
    if (tipoInversion == 'Manual' && isRunning) {
      phaseCounter++;
      if (phaseCounter % 2 == 0) {
        breathCount++;
      }
    }
  }

  int calculateNumBreaths(int listonInversion, int duracionMinutos) {
    double duracionRespiracionCompleta = 2 * (0.20 * listonInversion);
    int totalSegundos = duracionMinutos * 60;
    return (totalSegundos / duracionRespiracionCompleta).floor();
  }

  Future<void> _playBeep(int count) async {
    String beepSound = count == 1 ? 'sounds/beep1.wav' : 'sounds/beep2.wav';

    for (int i = 0; i < count; i++) {
      await player.play(AssetSource(beepSound));
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  void dispose() {
    _timer?.cancel();
    player.dispose();
  }
}
