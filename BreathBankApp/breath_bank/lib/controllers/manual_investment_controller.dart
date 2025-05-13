import 'package:flutter/material.dart';
import '../models/manual_investment_model.dart';

class ManualInvestmentController {
  final ManualInvestmentModel model;

  ManualInvestmentController(this.model);

  void initialize(BuildContext context, Map<String, dynamic> args) {
    final duracionMinutos = args['duracion'] as int;
    final listonInversion = args['liston'] as int;

    model.timeLimit = duracionMinutos * 60;
    model.investmentTime = model.timeLimit;
    model.targetBreaths = model.calculateNumBreaths(
      listonInversion,
      duracionMinutos,
    );
    model.duracionFase = 0.25 * listonInversion + 2.5;
    model.listonInversion = listonInversion;
  }

  void startTimer(Function onTick, Function onComplete) {
    model.startTimer(onTick, onComplete);
  }

  void stopTimer() {
    model.stopTimer();
  }

  void resetTimer() {
    model.resetTimer();
  }

  void markPhase() {
    model.markPhase();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  double get timeProgress =>
      model.timeLimit == 0 ? 0 : model.secondsElapsed / model.timeLimit;
  int get remainingSeconds => model.timeLimit - model.secondsElapsed;
}
