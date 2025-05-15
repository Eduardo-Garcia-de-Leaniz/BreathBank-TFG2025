import '../models/investment_test_model.dart';

class InvestmentTestController {
  final InvestmentTestModel model;

  InvestmentTestController(this.model);

  /// Inicializa los parámetros de la inversión
  void initialize(Map<String, dynamic> args, String tipoInversion) {
    final duracionMinutos = args['duracion'] as int;
    final listonInversion = args['liston'] as int;

    model.initialize(
      duracionMinutos: duracionMinutos,
      listonInversion: listonInversion,
      tipoInversion: tipoInversion,
    );
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

  /// Marca una fase (solo para inversiones manuales)
  void markPhase() {
    model.markPhase();
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
