import 'dart:async';
import 'package:breath_bank/models/test2_model.dart';

class Test2Controller {
  final Test2Model model = Test2Model();
  Timer? timer;
  bool isRunning = false;

  void startClock(void Function() updateUI) {
    if (timer == null) {
      isRunning = true;
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        model.elapsedSeconds += 1;
        updateUI();
      });
    }
  }

  void pauseClock(void Function(String) updateTextField) {
    isRunning = false;
    timer?.cancel();
    timer = null;
    model.testResult = model.elapsedSeconds;
    updateTextField(model.elapsedSeconds.toString());
  }

  void resetClock(void Function() updateUI) {
    timer?.cancel();
    timer = null;
    isRunning = false;
    model.elapsedSeconds = 0;
    model.testResult = 0;
    updateUI();
  }

  int get elapsedSeconds => model.elapsedSeconds;

  bool validateTestResult(String testResult) {
    return model.validateTestResult(testResult);
  }

  void dispose() {
    timer?.cancel();
  }
}
