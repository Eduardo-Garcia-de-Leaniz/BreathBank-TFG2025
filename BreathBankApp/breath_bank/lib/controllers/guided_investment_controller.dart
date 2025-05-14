import 'package:flutter/material.dart';
import '../models/guided_investment_model.dart';

class GuidedInvestmentController {
  final GuidedInvestmentModel model;

  GuidedInvestmentController(this.model);

  /// Inicializa los parámetros de la inversión guiada
  void initialize(BuildContext context, Map<String, dynamic> args) {
    final duracionMinutos = args['duracion'] as int;
    final listonInversion = args['liston'] as int;

    model.timeLimit = duracionMinutos * 60;
    model.targetBreaths = model.calculateNumBreaths(
      listonInversion,
      duracionMinutos,
    );
    model.duracionFase = 0.25 * listonInversion + 2.5;
    model.listonInversion = listonInversion;
  }

  /// Inicia el temporizador
  void startTimer(Function onTick, Function onComplete) {
    model.startTimer(onTick, onComplete);
  }

  /// Detiene el temporizador
  void stopTimer() {
    model.stopTimer();
  }

  /// Reinicia el temporizador
  void resetTimer() {
    model.resetTimer();
  }

  /// Formatea el tiempo en minutos y segundos
  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// Progreso del tiempo en porcentaje
  double get timeProgress =>
      model.timeLimit == 0 ? 0 : model.secondsElapsed / model.timeLimit;

  int get remainingSeconds => model.timeLimit - model.secondsElapsed;
}
