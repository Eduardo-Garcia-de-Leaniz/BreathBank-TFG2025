import 'package:breath_bank/widgets/breathing_animation_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/controllers/test3_controller.dart';
import 'package:breath_bank/models/test3_model.dart';
import 'package:flutter/material.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Test3Controller', () {
    late Test3Controller controller;
    late Test3Model model;
    late GlobalKey<BreathingAnimationWidgetState> dummyKey;

    setUp(() {
      controller = Test3Controller();
      model = controller.model;
      dummyKey = GlobalKey<BreathingAnimationWidgetState>();
    });

    test('Inicializa correctamente', () {
      expect(model.testResult, 0);
      expect(model.numBreaths, 0);
      expect(controller.isRunning, false);
      expect(controller.resultFieldController.text, '');
    });

    test('startOrPauseBreathing alterna isRunning y actualiza resultado', () {
      controller.startOrPauseBreathing(dummyKey);
      expect(controller.isRunning, true);

      controller.startOrPauseBreathing(dummyKey);
      expect(controller.isRunning, false);
      expect(controller.resultFieldController.text, '0');
      expect(model.testResult, 0);
    });

    test('resetBreathing reinicia valores', () {
      controller.isRunning = true;
      model.numBreaths = 5;
      model.testResult = 3;
      controller.resultFieldController.text = '3';

      controller.resetBreathing(dummyKey);

      expect(controller.isRunning, false);
      expect(model.numBreaths, 0);
      expect(model.testResult, 0);
      expect(controller.resultFieldController.text, '');
    });

    test('validateTestResult funciona correctamente', () {
      expect(model.validateTestResult('10'), true);
      expect(model.validateTestResult(''), false);
      expect(model.validateTestResult('abc'), false);
    });

    tearDown(() {
      controller.dispose();
    });
  });
}
