import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/controllers/test1_controller.dart';
import 'package:breath_bank/models/test1_model.dart';

class _MockTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Test1Controller', () {
    late Test1Controller controller;
    late Test1Model model;

    setUp(() {
      controller = Test1Controller();
      model = controller.model;
      controller.init(_MockTickerProvider());
    });

    test('Inicializa correctamente', () {
      expect(model.remainingTime, model.testDuration);
      expect(controller.isRunning, false);
      expect(
        controller.animationController.duration!.inSeconds,
        model.testDuration,
      );
    });

    test('startClock y pauseClock funcionan', () {
      controller.startClock();
      expect(controller.isRunning, true);

      controller.pauseClock();
      expect(controller.isRunning, false);
    });

    test('resetClock reinicia el temporizador', () {
      controller.startClock();
      controller.resetClock();
      expect(model.remainingTime, model.testDuration);
      expect(controller.isRunning, false);
    });

    test('validateTestResult funciona correctamente', () {
      expect(model.validateTestResult('10'), true);
      expect(model.validateTestResult(''), false);
      expect(model.validateTestResult('abc'), false);
    });
  });
}
