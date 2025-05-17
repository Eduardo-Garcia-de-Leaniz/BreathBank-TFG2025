import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/controllers/test2_controller.dart';
import 'package:breath_bank/models/test2_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Test2Controller', () {
    late Test2Controller controller;
    late Test2Model model;

    setUp(() {
      controller = Test2Controller();
      model = controller.model;
    });

    test('Inicializa correctamente', () {
      expect(model.elapsedSeconds, 0);
      expect(model.testResult, 0);
      expect(controller.isRunning, false);
    });

    test('startClock y pauseClock funcionan', () async {
      int uiUpdates = 0;
      controller.startClock(() {
        uiUpdates++;
      });
      expect(controller.isRunning, true);

      // Simula 2 segundos de timer
      await Future.delayed(const Duration(seconds: 2));
      controller.pauseClock((value) {});
      expect(controller.isRunning, false);
      expect(model.testResult, model.elapsedSeconds);
      expect(model.elapsedSeconds >= 2, true);
      expect(uiUpdates >= 2, true);
    });

    test('resetClock reinicia el temporizador', () async {
      controller.startClock(() {});
      await Future.delayed(const Duration(seconds: 1));
      controller.resetClock(() {});
      expect(model.elapsedSeconds, 0);
      expect(model.testResult, 0);
      expect(controller.isRunning, false);
    });

    test('validateTestResult funciona correctamente', () {
      expect(model.validateTestResult('10'), true);
      expect(model.validateTestResult(''), false);
      expect(model.validateTestResult('abc'), false);
    });
  });
}
