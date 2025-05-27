import 'dart:async';
import 'package:breath_bank/models/test2_model.dart';

class Test2Controller {
  final Test2Model model = Test2Model();
  Timer? timer;
  bool isRunning = false;

  void startClock(void Function() updateUI) {
    if (timer == null) {
      // Solo inicia un nuevo temporizador si no hay uno activo
      isRunning = true;
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        model.elapsedSeconds += 1;
        updateUI(); // Actualiza la interfaz de usuario cada segundo
      });
    }
  }

  void pauseClock(void Function(String) updateTextField) {
    isRunning = false;
    timer?.cancel();
    timer = null;
    model.testResult = model.elapsedSeconds;
    updateTextField(model.elapsedSeconds.toString()); // Actualiza el TextField
  }

  void resetClock(void Function() updateUI) {
    timer?.cancel(); // Detiene el temporizador actual
    timer = null;
    isRunning = false;
    model.elapsedSeconds = 0; // Restablece el tiempo transcurrido
    model.testResult = 0; // Restablece el resultado del test
    updateUI(); // Actualiza la interfaz de usuario
  }

  int get elapsedSeconds => model.elapsedSeconds;

  bool validateTestResult(String testResult) {
    return model.validateTestResult(testResult);
  }

  void dispose() {
    timer?.cancel();
  }
}
