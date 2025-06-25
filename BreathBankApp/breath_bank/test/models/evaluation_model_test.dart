import 'package:flutter_test/flutter_test.dart';
import 'package:breath_bank/models/evaluation_model.dart';

void main() {
  late EvaluationModel model;

  setUp(() {
    model = EvaluationModel();
  });

  group('Resultados Test1', () {
    test('devuelve 10 para resultado <= 1', () {
      expect(model.calculateTest1Result(0), 10);
      expect(model.calculateTest1Result(1), 10);
    });
    test('devuelve 9 para resultado == 2', () {
      expect(model.calculateTest1Result(2), 9);
    });
    test('devuelve 0 para resultado >= 11', () {
      expect(model.calculateTest1Result(11), 0);
      expect(model.calculateTest1Result(20), 0);
    });
  });

  group('Resultados Test2', () {
    test('devuelve 10 para resultado >= 180', () {
      expect(model.calculateTest2Result(180), 10);
      expect(model.calculateTest2Result(200), 10);
    });
    test('devuelve 5 para resultado == 60', () {
      expect(model.calculateTest2Result(60), 5);
    });
    test('devuelve 0 para resultado < 20', () {
      expect(model.calculateTest2Result(10), 0);
    });
  });

  group('Resultados Test3', () {
    test('devuelve 0 para resultado <= 2', () {
      expect(model.calculateTest3Result(1), 0);
      expect(model.calculateTest3Result(2), 0);
    });
    test('devuelve 10 para resultado > 40', () {
      expect(model.calculateTest3Result(41), 10);
      expect(model.calculateTest3Result(100), 10);
    });
    test('devuelve 5 para resultado entre 11 y 14', () {
      expect(model.calculateTest3Result(12), 5);
      expect(model.calculateTest3Result(14), 5);
    });
  });

  group('Resultados nivel de inversor', () {
    test('calcula correctamente el nivel de inversor', () {
      model.resultTest1 = 2;
      model.resultTest2 = 180;
      model.resultTest3 = 41;
      expect(
        model.calculateInversorLevel(),
        ((9 * 20 + 10 * 30 + 10 * 50) / 100).round(),
      );
    });
  });

  group('Test completados', () {
    test('por defecto todos los tests están en false', () {
      expect(model.testCompleted['test1'], isFalse);
      expect(model.testCompleted['test2'], isFalse);
      expect(model.testCompleted['test3'], isFalse);
    });
    test('puede marcar un test como completado', () {
      model.testCompleted['test1'] = true;
      expect(model.testCompleted['test1'], isTrue);
    });
  });
}
