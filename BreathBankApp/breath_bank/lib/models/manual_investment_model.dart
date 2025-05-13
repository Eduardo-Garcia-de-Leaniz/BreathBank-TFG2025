import 'dart:async';

class ManualInvestmentModel {
  int secondsElapsed = 0;
  int phaseCounter = 0;
  int breathCount = 0;
  bool isRunning = false;
  bool hasStarted = false;
  bool isTimeUp = false;
  int timeLimit = 0;
  int investmentTime = 0;
  int targetBreaths = 0;
  double duracionFase = 0;
  int listonInversion = 0;
  String tipoInversion = 'Manual';

  Timer? _timer;

  void startTimer(Function onTick, Function onComplete) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsElapsed >= timeLimit) {
        stopTimer();
        onComplete();
      } else {
        secondsElapsed++;
        onTick();
      }
    });
    isRunning = true;
    hasStarted = true;
    isTimeUp = false;
  }

  void stopTimer() {
    _timer?.cancel();
    if (secondsElapsed >= timeLimit) {
      isTimeUp = true;
    }
    isRunning = false;
  }

  void resetTimer() {
    _timer?.cancel();
    secondsElapsed = 0;
    breathCount = 0;
    phaseCounter = 0;
    isRunning = false;
    hasStarted = false;
    isTimeUp = false;
  }

  void markPhase() {
    if (isRunning) {
      phaseCounter++;
      if (phaseCounter % 2 == 0) {
        breathCount++;
      }
    }
  }

  int calculateNumBreaths(int listonInversion, int duracionMinutos) {
    double duracionRespiracionCompleta = 2 * (0.25 * listonInversion + 2.5);
    int totalSegundos = duracionMinutos * 60;
    return (totalSegundos / duracionRespiracionCompleta).floor();
  }

  void dispose() {
    _timer?.cancel();
  }
}
