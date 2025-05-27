import 'package:breath_bank/models/test3_model.dart';
import 'package:breath_bank/widgets/breathing_animation_widget.dart';
import 'package:flutter/material.dart';

class Test3Controller {
  final Test3Model model = Test3Model();
  final TextEditingController resultFieldController = TextEditingController();
  bool isRunning = false;

  void startOrPauseBreathing(GlobalKey<BreathingAnimationWidgetState> key) {
    isRunning = !isRunning;

    if (isRunning) {
      key.currentState?.resume();
    } else {
      key.currentState?.pause();
      final last = key.currentState?.getCurrentBreathCount() ?? 0;
      resultFieldController.text = last.toString();
      model.testResult = last;
    }
  }

  void resetBreathing(GlobalKey<BreathingAnimationWidgetState> key) {
    isRunning = false;
    model.numBreaths = 0;
    model.testResult = 0;
    resultFieldController.clear();
    key.currentState?.reset();
  }

  bool validateTestResult(String testResult) {
    return model.validateTestResult(testResult);
  }

  void dispose() {
    resultFieldController.dispose();
  }
}
