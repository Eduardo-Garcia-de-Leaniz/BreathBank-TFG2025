import 'package:flutter/material.dart';
import 'package:breath_bank/models/test1_model.dart';

class Test1Controller {
  final Test1Model model = Test1Model();
  late AnimationController animationController;
  bool isRunning = false;

  void init(TickerProvider vsync) {
    animationController = AnimationController(
      vsync: vsync,
      duration: Duration(seconds: model.testDuration),
    );

    animationController.addListener(() {
      model.remainingTime =
          (animationController.duration!.inSeconds * animationController.value)
              .round();
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        isRunning = false;
        animationController.reset();
      }
    });
  }

  void startClock() {
    isRunning = true;
    animationController.reverse(
      from: animationController.value == 0.0 ? 1.0 : animationController.value,
    );
  }

  void pauseClock() {
    animationController.stop();
    isRunning = false;
  }

  void resetClock() {
    animationController.reset();
    model.remainingTime = model.testDuration;
    isRunning = false;
  }

  int get remainingTime => model.remainingTime;

  void dispose() {
    animationController.dispose();
  }
}
