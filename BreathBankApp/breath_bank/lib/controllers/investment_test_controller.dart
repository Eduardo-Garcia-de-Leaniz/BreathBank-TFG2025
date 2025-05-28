import '../models/investment_test_model.dart';

class InvestmentTestController {
  final InvestmentTestModel model;

  InvestmentTestController(this.model);

  void initialize(Map<String, dynamic> args, String tipoInversion) {
    final duracionMinutos = args['duracion'] as int;
    final listonInversion = args['liston'] as int;

    model.initialize(
      duracionMinutos: duracionMinutos,
      listonInversion: listonInversion,
      tipoInversion: tipoInversion,
    );
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
